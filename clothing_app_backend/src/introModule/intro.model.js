const mongoose = require('mongoose');

const introSchema = new mongoose.Schema({
  intro_title: {
    type: String,
    required: true
  },
  intro_description: {
    type: String,
    required: false
  },
  images: {
    type: [String],
    required: true
  }
});


const Intro = mongoose.model("Intro", introSchema);
export default Intro;