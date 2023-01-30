export const CopyHook = {
  mounted() {
    this.el.addEventListener("click", async evt => {
      evt.preventDefault()

      const text = document.querySelector(this.el.dataset.to).innerText
      await navigator.clipboard.writeText(text)

      this.el.classList.add("hidden")
      this.el.nextElementSibling.classList.remove("hidden")

      if (this.hideTimeout) {
        clearTimeout(this.hideTimeout)
      }

      this.hideTimeout = setTimeout(() => {
        this.el.classList.remove("hidden")
        this.el.nextElementSibling.classList.add("hidden")
      }, 1500)
    })
  },
  destroyed() {
    clearTimeout(this.hideTimeout)
  }
}
