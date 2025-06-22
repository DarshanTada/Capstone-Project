import axios from 'axios'

const LLAVA_API_URL = process.env.LLAVA_API_URL || 'http://localhost:11434/api/chat'

export interface LlavaMessage {
  role: string
  content: string
}

export async function callLlavaAI(
  messages: LlavaMessage[],
  model: string = 'llava',
  stream: boolean = false
) {
  try {
    const response = await axios.post(
      LLAVA_API_URL,
      {
        model,
        messages,
        stream,
      },
      {
        headers: {
          'Content-Type': 'application/json',
        },
      }
    )
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || error.message)
  }
}