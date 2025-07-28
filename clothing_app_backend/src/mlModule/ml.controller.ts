import { Request, Response } from "express";
import axios from "axios";
import fs from "fs";
import FormData from "form-data";
import mongoose from "mongoose";
import Preference from "../preferenceModule/preference.model";
import { MLAnalysis, MLSession, ML_REQUEST_TYPES } from "./ml.model";

const baseURL = process.env.PYTHON_SERVER_URL || "http://localhost:8000"; // fallback

// Health check for Python server
export const checkPythonServerHealth = async (req: Request, res: Response): Promise<void> => {
  try {
    console.log(`Checking Python server health at: ${baseURL}`);
    const response = await axios.get(`${baseURL}/health`, { timeout: 10000 });
    res.status(200).json({ 
      status: "healthy", 
      python_server: baseURL,
      response: response.data 
    });
  } catch (err: any) {
    console.error('Python server health check failed:', {
      message: err.message,
      code: err.code,
      status: err.response?.status
    });
    res.status(503).json({ 
      status: "unhealthy", 
      python_server: baseURL,
      error: err.message,
      code: err.code
    });
  }
};

export const uploadFile = async (req: Request, res: Response): Promise<void> => {
  if (!req.file) {
    res.status(400).json({ error: "File is required." });
    return;
  }

  try {
    const form = new FormData();
    form.append("file", fs.createReadStream(req.file.path));

    const response = await axios.post(`${baseURL}/upload/`, form, {
      headers: form.getHeaders(),
    });

    res.status(200).json(response.data);
  } catch (err: any) {
    console.error(err.message);
    res.status(500).json({ error: "Upload failed." });
  }
};

export const askQuestion = async (req: Request, res: Response): Promise<void> => {
  const { question, system_prompt, image, user_id } = req.body;

  if (!question) {
    res.status(400).json({ error: "Question is required." });
    return;
  }

  try {
    console.log(`Making request to: ${baseURL}/ask/`);
    console.log('Request body:', { 
      question, 
      system_prompt: system_prompt || "", 
      image_provided: !!image,
      user_id: user_id || null 
    });

    const response = await axios.post(
      `${baseURL}/ask/`,
      {
        question,
        system_prompt: system_prompt || "",
        image_base64: image || null, 
        user_id: user_id || null,
      },
      { timeout: 120000 }
    );
    
    console.log('Response received:', response.status);
    res.status(200).json(response.data);
  } catch (err: any) {
    console.error('Error details:', {
      message: err.message,
      status: err.response?.status,
      statusText: err.response?.statusText,
      data: err.response?.data,
      code: err.code,
      baseURL
    });
    
    if (err.response) {
      // Server responded with error status
      res.status(err.response.status || 500).json({ 
        error: "Query failed.", 
        details: err.response.data || err.message,
        python_server_status: err.response.status
      });
    } else if (err.code === 'ECONNREFUSED' || err.code === 'ENOTFOUND') {
      // Connection refused or DNS error
      res.status(503).json({ 
        error: "Python ML server is not accessible.", 
        details: `Cannot connect to ${baseURL}`,
        code: err.code
      });
    } else {
      // Other network or timeout errors
      res.status(500).json({ 
        error: "Query failed.", 
        details: err.message,
        code: err.code
      });
    }
  }
};

export const analyzeUserPreferences = async (req: Request, res: Response): Promise<void> => {
  const { user_id, image_base64 } = req.body;

  if (!user_id || !image_base64) {
    res.status(400).json({ error: "user_id and image_base64 are required." });
    return;
  }

  try {
    // Define the system prompt for preference analysis
    const systemPrompt = `You are a fashion and style analysis expert. Analyze the person in the image and provide specific details about their characteristics that would help determine clothing preferences.

    CRITICAL: You MUST respond with ONLY a valid JSON object. Do not include any explanatory text before or after the JSON.

    Return EXACTLY this JSON structure with your analysis:
    {
      "gender": "male/female/other",
      "age": 25,
      "height": 170,
      "body_type": "ectomorph/mesomorph/endomorph/hourglass/pear/apple/rectangle/inverted_triangle",
      "skin_tone": "very_fair/fair/light/medium/tan/dark/very_dark",
      "style": ["casual", "formal", "sporty", "bohemian", "classic", "trendy"],
      "color_tones": ["warm", "cool", "neutral"],
      "undertone": "warm/cool/neutral"
    }

    Analysis guidelines:
    - gender: Determine from visible characteristics
    - age: Estimate age as a number
    - height: Estimate height in centimeters (e.g., 170)
    - body_type: Choose the most appropriate body type
    - skin_tone: Analyze skin color depth
    - style: List 2-3 applicable style categories from the options
    - color_tones: List applicable color temperature preferences
    - undertone: Determine warm, cool, or neutral undertones

    IMPORTANT: Return ONLY the JSON object, no other text whatsoever.`;

    const question = "Analyze this person's characteristics and return only the JSON response with their style profile.";

    // Call the LLaVA API
    const response = await axios.post(
      `${baseURL}/ask/`,
      {
        question,
        system_prompt: systemPrompt,
        image_base64: image_base64,
        user_id: user_id,
      },
      { timeout: 120000 }
    );

    // Parse the response
    let analysisResult: any;
    try {
      // Extract JSON from the response
      const responseText = response.data.response || response.data;
      console.log("Raw LLaVA response:", responseText);
      
      // Try multiple strategies to extract JSON
      let jsonString = responseText;
      
      // Strategy 1: Look for JSON block
      const jsonMatch = responseText.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        jsonString = jsonMatch[0];
      }
      
      // Strategy 2: Clean up common text patterns
      jsonString = jsonString
        .replace(/^.*?(\{)/, '$1') // Remove everything before first {
        .replace(/(\}).*$/, '$1')  // Remove everything after last }
        .trim();
      
      console.log("Extracted JSON string:", jsonString);
      
      // Try to parse the JSON
      analysisResult = JSON.parse(jsonString);
      
      // Validate required fields
      const requiredFields = ['gender', 'age', 'height', 'body_type', 'skin_tone', 'style', 'color_tones', 'undertone'];
      const missingFields = requiredFields.filter(field => !analysisResult.hasOwnProperty(field));
      
      if (missingFields.length > 0) {
        throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
      }
      
    } catch (parseError) {
      console.error("Failed to parse LLaVA response:", parseError);
      console.error("Raw response:", response.data);
      
      // Fallback: Create a default response based on the text analysis
      analysisResult = createFallbackAnalysis(response.data.response || response.data);
      
      console.log("Using fallback analysis:", analysisResult);
    }

    // Check if user already has preferences
    const existingPreference = await Preference.findOne({ user_objectId: user_id });

    let savedPreference;
    if (existingPreference) {
      // Update existing preference
      savedPreference = await Preference.findOneAndUpdate(
        { user_objectId: user_id },
        {
          ...analysisResult,
          user_objectId: user_id,
        },
        { new: true }
      );
    } else {
      // Create new preference
      const newPreference = new Preference({
        ...analysisResult,
        user_objectId: user_id,
      });
      
      savedPreference = await newPreference.save();
    }

    // Log the ML analysis
    try {
      const mlAnalysis = new MLAnalysis({
        user_objectId: user_id,
        request_type: 'preference_analysis',
        input_data: {
          question,
          system_prompt: systemPrompt,
          image_base64: image_base64.substring(0, 100) + '...', // Store truncated version
        },
        analysis_result: {
          response: JSON.stringify(analysisResult),
          confidence_score: 0.8, // Default confidence
          processing_time_ms: Date.now() - Date.now(), // This would need proper timing
          extracted_data: analysisResult
        },
        status: 'completed'
      });
      
      await mlAnalysis.save();
    } catch (logError) {
      console.error("Failed to log ML analysis:", logError);
      // Don't fail the main request if logging fails
    }

    const responseMessage = existingPreference 
      ? "User preferences updated successfully"
      : "User preferences created successfully";

    res.status(existingPreference ? 200 : 201).json({ 
      success: true, 
      data: savedPreference,
      message: responseMessage,
      analysis_details: {
        raw_response: response.data.response || response.data,
        parsed_data: analysisResult
      }
    });

  } catch (err: any) {
    console.error("Preference analysis error:", err);
    res.status(500).json({ error: "Failed to analyze user preferences." });
    return;
  }
};

// Fallback function to create structured data from text response
function createFallbackAnalysis(responseText: string): any {
  console.log("Creating fallback analysis from:", responseText);
  
  const defaultAnalysis = {
    gender: "other",
    age: 25,
    height: 170,
    body_type: "rectangle",
    skin_tone: "medium",
    style: ["casual"],
    color_tones: ["neutral"],
    undertone: "neutral"
  };

  try {
    const text = responseText.toLowerCase();
    
    // Analyze gender
    if (text.includes("male") && !text.includes("female")) {
      defaultAnalysis.gender = "male";
    } else if (text.includes("female") && !text.includes("male")) {
      defaultAnalysis.gender = "female";
    }
    
    // Analyze body type
    if (text.includes("inverted triangle")) {
      defaultAnalysis.body_type = "inverted_triangle";
    } else if (text.includes("pear") || text.includes("triangle")) {
      defaultAnalysis.body_type = "pear";
    } else if (text.includes("apple")) {
      defaultAnalysis.body_type = "apple";
    } else if (text.includes("hourglass")) {
      defaultAnalysis.body_type = "hourglass";
    } else if (text.includes("rectangle")) {
      defaultAnalysis.body_type = "rectangle";
    } else if (text.includes("ectomorph")) {
      defaultAnalysis.body_type = "ectomorph";
    } else if (text.includes("mesomorph")) {
      defaultAnalysis.body_type = "mesomorph";
    } else if (text.includes("endomorph")) {
      defaultAnalysis.body_type = "endomorph";
    }
    
    // Analyze style preferences
    const styles = [];
    if (text.includes("casual")) styles.push("casual");
    if (text.includes("formal")) styles.push("formal");
    if (text.includes("sporty") || text.includes("athletic")) styles.push("sporty");
    if (text.includes("bohemian") || text.includes("boho")) styles.push("bohemian");
    if (text.includes("classic")) styles.push("classic");
    if (text.includes("trendy") || text.includes("modern")) styles.push("trendy");
    
    if (styles.length > 0) {
      defaultAnalysis.style = styles.slice(0, 3); // Max 3 styles
    }
    
    // Analyze color tones
    const colorTones = [];
    if (text.includes("warm")) colorTones.push("warm");
    if (text.includes("cool")) colorTones.push("cool");
    if (text.includes("neutral")) colorTones.push("neutral");
    
    if (colorTones.length > 0) {
      defaultAnalysis.color_tones = colorTones;
      defaultAnalysis.undertone = colorTones[0]; // Use first detected tone as undertone
    }
    
    // Extract age if mentioned
    const ageMatch = text.match(/(\d{1,2})\s*(years?\s*old|age)/);
    if (ageMatch) {
      const age = parseInt(ageMatch[1]);
      if (age >= 10 && age <= 100) {
        defaultAnalysis.age = age;
      }
    }
    
    // Extract height if mentioned
    const heightMatch = text.match(/(\d{3})\s*(cm|centimeter)/);
    if (heightMatch) {
      const height = parseInt(heightMatch[1]);
      if (height >= 140 && height <= 220) {
        defaultAnalysis.height = height;
      }
    }
    
  } catch (error) {
    console.error("Error in fallback analysis:", error);
  }
  
  return defaultAnalysis;
}

// Get ML Analysis History for a user
export const getAnalysisHistory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;
    const { type, limit = 10, page = 1 } = req.query;

    if (!userId) {
      res.status(400).json({ success: false, message: 'userId is required in params.' });
      return;
    }

    const filter: any = { user_objectId: userId };
    if (type && ML_REQUEST_TYPES.includes(type as string)) {
      filter.request_type = type;
    }

    const skip = (Number(page) - 1) * Number(limit);
    
    const analyses = await MLAnalysis.find(filter)
      .sort({ created_at: -1 })
      .limit(Number(limit))
      .skip(skip)
      .populate('user_objectId', 'name email');

    const total = await MLAnalysis.countDocuments(filter);

    res.status(200).json({
      success: true,
      data: analyses,
      pagination: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / Number(limit))
      }
    });
  } catch (error: any) {
    console.error('Get analysis history error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get ML Sessions for a user
export const getUserSessions = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;

    if (!userId) {
      res.status(400).json({ success: false, message: 'userId is required in params.' });
      return;
    }

    const sessions = await MLSession.find({ user_objectId: userId })
      .sort({ last_activity: -1 })
      .populate('interactions.request_id');

    res.status(200).json({
      success: true,
      data: sessions
    });
  } catch (error: any) {
    console.error('Get user sessions error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete ML Analysis record
export const deleteAnalysis = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    if (!id) {
      res.status(400).json({ success: false, message: 'Analysis ID is required.' });
      return;
    }

    const deletedAnalysis = await MLAnalysis.findByIdAndDelete(id);

    if (!deletedAnalysis) {
      res.status(404).json({ success: false, message: 'Analysis record not found.' });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Analysis record deleted successfully'
    });
  } catch (error: any) {
    console.error('Delete analysis error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get ML statistics
export const getMLStats = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.query;

    let matchFilter: any = {};
    if (userId) {
      matchFilter.user_objectId = new mongoose.Types.ObjectId(userId as string);
    }

    const stats = await MLAnalysis.aggregate([
      { $match: matchFilter },
      {
        $group: {
          _id: "$request_type",
          count: { $sum: 1 },
          avgProcessingTime: { $avg: "$analysis_result.processing_time_ms" },
          successRate: {
            $avg: {
              $cond: [{ $eq: ["$status", "completed"] }, 1, 0]
            }
          }
        }
      }
    ]);

    const totalRequests = await MLAnalysis.countDocuments(matchFilter);
    const completedRequests = await MLAnalysis.countDocuments({ 
      ...matchFilter, 
      status: "completed" 
    });

    res.status(200).json({
      success: true,
      data: {
        totalRequests,
        completedRequests,
        overallSuccessRate: totalRequests > 0 ? completedRequests / totalRequests : 0,
        typeStats: stats
      }
    });
  } catch (error: any) {
    console.error('Get ML stats error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
