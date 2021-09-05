defmodule LovWeb.PostcardLive do
  use LovWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp upload_form() do
    assigns = %{}

    ~L"""
    <div class="p-4">
      <div class="max-w-lg flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-md">
        <label class="font-medium text-indigo-600 hover:text-indigo-500 cursor-pointer focus:outline-none focus:underline transition duration-150 ease-in-out">
          <div class="text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
              <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
            <p class="mt-1 text-sm text-gray-600">
              <span class="font-medium text-indigo-600 hover:text-indigo-500 focus:outline-none focus:underline transition duration-150 ease-in-out">
                Upload a Photo
              </span>
              <input id="file-input"
                      phx-hook="Uploader"
                      type="file" accept="image/jpeg" class="hidden"
              />
            </p>
          </div>
        </label>
      </div>
    </div>
    """
  end

end