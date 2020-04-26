// src/controllers/upload_controller.js
import { Controller } from "stimulus"
// import { Uppy, FileInput, ProgressBar, ThumbnailGenerator, Tus  } from 'uppy' 
// import Uppy, { FileInput, ProgressBar, ThumbnailGenerator, Tus  } from 'uppy' 
// import { Uppy } from "@uppy/core"
const Uppy = require('@uppy/core')
// import { FileInput } from "@uppy/file-input"
const FileInput = require('@uppy/file-input')
// import { ProgressBar } from "@uppy/progress-bar"
// // const StatusBar = require('@uppy/status-bar')
const ProgressBar = require('@uppy/progress-bar')
// import { ThumbnailGenerator } from "@uppy/thumbnail-generator"
const ThumbnailGenerator = require('@uppy/thumbnail-generator')
// import { Tus } from "@uppy/tus"
const Tus = require('@uppy/tus')

require('@uppy/core/dist/style.css')
require('@uppy/file-input/dist/style.css')
require('@uppy/progress-bar/dist/style.css')

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
      target: document.getElementById("upload-div"),
      pretty: true,
      locale: {
       strings: {chooseFiles: 'add Photo'}
      } 
    })
    .use(Tus, { 
      endpoint: 'https://lov.is/upload/', 
      limit: 5, 
      resume: true, 
      autoRetry: true, 
      retryDelays: [0, 1000, 3000, 5000] 
    })
    .use(ProgressBar, {
      target: document.getElementById("progress-div"),
      hideAfterFinish: true
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
    .setMeta({ upload_token: document.getElementById('main').getAttribute('data-value') })
  }

}
