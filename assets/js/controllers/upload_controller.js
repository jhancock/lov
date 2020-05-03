// src/controllers/upload_controller.js
import { Controller } from "stimulus"
// import { Uppy, FileInput, ProgressBar, ThumbnailGenerator, Tus  } from 'uppy' 
// import Uppy, { FileInput, ProgressBar, ThumbnailGenerator, Tus  } from 'uppy' 
import { Uppy } from "@uppy/core"
// const Uppy = require('@uppy/core')
// import { FileInput } from "@uppy/file-input"
// const FileInput = require('@uppy/file-input')
// // const StatusBar = require('@uppy/status-bar')
// import { ProgressBar } from "@uppy/progress-bar"
const ProgressBar = require('@uppy/progress-bar')
// import { ThumbnailGenerator } from "@uppy/thumbnail-generator"
const ThumbnailGenerator = require('@uppy/thumbnail-generator')
// import { Tus } from "@uppy/tus"
const Tus = require('@uppy/tus')

// require('@uppy/core/dist/style.css')
// require('@uppy/file-input/dist/style.css')
require('@uppy/progress-bar/dist/style.css')

export default class extends Controller {

  connect() {
    console.log("Upploadd!", this.element)
    this.uppy = this.createUppy()
    this.configureUppy(this.uppy)
  }

  initialize() {
    // console.log("uppy initialized...", this.createUppy())
  }
  
  createUppy() {
    return new Uppy({
      debug: true,
      autoProceed: true,
      restrictions: {
        maxFileSize: 10000000,
        maxNumberOfFiles: 1,
        minNumberOfFiles: 1,
        allowedFileTypes: ['image/jpeg']
      }
    })
  }

  configureUppy(uppy) {
    uppy
    .use(Tus, { 
      endpoint: 'https://lov.is/upload/', 
      limit: 5, 
      resume: true, 
      autoRetry: true, 
      retryDelays: [0, 1000, 3000, 5000] 
    })
    .use(ProgressBar, {
      target: document.querySelector("#progress-div"),
      hideAfterFinish: true
    })
    .use(ThumbnailGenerator, {
      thumbnailWidth: 400,
      // thumbnailHeight: 200 // optional, use either width or height,
      waitForThumbnailsBeforeUpload: false
    })
    .on('thumbnail:generated', (file, preview) => {
      // const uploadDiv = this.element
      const uploadDiv = document.querySelector("#progress-div")
      // const uploadDiv = document.getElementById("progress-div")
      const img = document.createElement('img')
      img.src = preview
      img.width = 400
      uploadDiv.appendChild(img)
    })
    .setMeta({ upload_token: this.getUploadToken() })
  }

  getUploadToken() {
    const element = document.head.querySelector(`meta[name="id"]`)
    return element.getAttribute("content")
  }

  fileSelected(event) {
    console.log("uppy be...", this.uppy)

    const files = Array.from(event.target.files)
    console.log("file selected", files)

    files.forEach((file) => {
      try {
        this.uppy.addFile({
          source: 'file input',
          name: file.name,
          type: file.type,
          data: file
        })
      } catch (err) {
        if (err.isRestriction) {
          // handle restrictions
          console.log('Restriction error:', err)
        } else {
          // handle other errors
          console.error(err)
        }
      }
    })
  }

}
