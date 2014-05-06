REBOL[
  purpose: {Speak user generated text.}
  author: "Giulio Lunati <giuliolunati@gmail.com>"
]

message: sl4a dialogGetInput ["TTS" "What would you like to say?" none]
sl4a ttsSpeak message/result
