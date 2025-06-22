import express from 'express'
import { askLlava } from './llava.controller'

export const LlavaRoute = express.Router()

// api/llava/ask
LlavaRoute.post('/ask', askLlava)

export default LlavaRoute