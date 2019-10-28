// src/controllers/upload_controller.js
import { Controller } from "stimulus"
const Uppy = require('@uppy/core')
const FileInput = require('@uppy/file-input')
const StatusBar = require('@uppy/status-bar')
const ThumbnailGenerator = require('@uppy/thumbnail-generator')
const Tus = require('@uppy/tus')

export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element)
  }

  initialize() {
    this.createUppy()
  }

  createUppy() {
    this.uppy = new Uppy({
      debug: true,
      autoProceed: true,
      restrictions: {
        maxFileSize: 10000000,
        maxNumberOfFiles: 1,
        minNumberOfFiles: 1,
        allowedFileTypes: ['image/jpeg', 'image/png']
      }
    })
    .use(FileInput, {
      target: '.UppyInput', pretty: false 
    })
    .use(Tus, { 
      endpoint: 'https://lov.is/upload/', 
      limit: 5, 
      resume: true, 
      autoRetry: true, 
      retryDelays: [0, 1000, 3000, 5000] 
    })
    .use(StatusBar, {
      target: '.UppyInput-Progress',
      hideUploadButton: true,
      hideAfterFinish: false
    })
    .use(ThumbnailGenerator, {
      thumbnailWidth: 400,
      // thumbnailHeight: 200 // optional, use either width or height,
      waitForThumbnailsBeforeUpload: false
    })
    .on('thumbnail:generated', (file, preview) => {
      const uploadDiv = document.getElementById("progress-div")
      const img = document.createElement('img')
      img.src = preview
      img.width = 400
      uploadDiv.appendChild(img)
    })
  }

}
