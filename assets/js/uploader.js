import { Uppy } from "@uppy/core"
const ProgressBar = require('@uppy/progress-bar')
const ThumbnailGenerator = require('@uppy/thumbnail-generator')
const Tus = require('@uppy/tus')
require('@uppy/progress-bar/dist/style.css')

const Uploader = {
  mounted() {
    this.el.addEventListener("input", e => {
      this.fileSelected(e)
    })
  },

  fileSelected(event) {
    const files = Array.from(event.target.files)
    const uppy = this.createUppy()
    this.configureUppy(uppy)
    console.log("file selected", files)

    files.forEach((file) => {
      try {
        uppy.addFile({
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
  },

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
  },

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
      const uploadDiv = document.querySelector(".text-center")
      // const uploadDiv = document.getElementById("progress-div")
      const img = document.createElement('img')
      img.src = preview
      img.width = 400
      uploadDiv.appendChild(img)
    })
    .setMeta({ upload_token: this.getUploadToken() })
  },

  getUploadToken() {
    const element = document.head.querySelector(`meta[name="id"]`)
    return element.getAttribute("content")
  },

};

export default Uploader;