import { Request, Response } from 'express'
import { callLlavaAI } from '../externalServices/llava.service'

export const askLlava = async (req: Request, res: Response): Promise<void> => {
  try {
    const { messages, model, stream } = req.body
    if (!messages || !Array.isArray(messages)) {
      res.status(400).json({ success: false, message: 'messages array is required' })
      return
    }
    const data = await callLlavaAI(messages, model, stream)
    res.status(200).json({ success: true, data })
    return
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message })
    return
  }
}