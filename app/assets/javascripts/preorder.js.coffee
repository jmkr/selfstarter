Selfstarter =
  firstTime: true
  validateEmailAndPassword: ->
    # The regex we use for validating email
    # It probably should be a parser, but there isn't enough time for that (Maybe in the future though!)
    if /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.test($("#email").val()) && $("#password").val() == $("#passwordConfirm").val() && $("#password").val() != "" && $("#password").val().length >= 6
      $("#email").removeClass("highlight")
      $("#email_next_button").removeClass("disabled")
    else
      $("#email").addClass("highlight") unless Selfstarter.firstTime
      $("#email_next_button").addClass("disabled") unless $("#email_next_button").hasClass("disabled")
  validateShippingForm: ->
    console.log("validating password")
    if $("#password").val() != $("#passwordConfirm").val()
      $("#email_next_button").addClass("disabled") unless $("#email_next_button").hasClass("disabled")
    else
      $("#email_next_button").removeClass("disabled")
  init: ->
    checkoutOffset = $('body').height() - $('.footer').outerHeight() #needs to be done upon init

    # Accounts for user already logged in and starting a checkout.
    if $("#email_next_button").hasClass("disabled")
      $("#email_next_button").removeClass("disabled")

    $("#email").bind "textchange", ->
      Selfstarter.validateEmailAndPassword()
    $("#email").bind "hastext", ->
      Selfstarter.validateEmailAndPassword()
    # The first time they type in their email, we don't want it to throw a validation error
    $("#email").change ->
      Selfstarter.firstTime = false

    $("#password").bind "textchange", ->
      Selfstarter.validateEmailAndPassword()
    $("#password").bind "hastext", ->
      Selfstarter.validateEmailAndPassword()
    $("#password").change ->
      Selfstarter.firstTime = false

    $("#passwordConfirm").bind "textchange", ->
      Selfstarter.validateEmailAndPassword()
    $("#passwordConfirm").bind "hastext", ->
      Selfstarter.validateEmailAndPassword()
    $("#passwordConfirm").change ->
      Selfstarter.firstTime = false 

    # After entering email, show shipping address form.
    $("#email_next_button").on "click", ->
      $(".email_and_next").hide()
      $(".shipping_and_checkout").removeClass("hidden")
      $(".shipping_and_checkout").css('display', 'block').animate

    # Handle a back button press, allowing user to change email.
    $("#shipping_back_button").on "click", ->
      $(".shipping_and_checkout").hide()
      $(".email_and_next").show()

    # Handle a back button press, allowing user to change email.
    #$("#amazon_button").on "click", ->
    #  Selfstarter.validateShippingForm()

    # init placeholder image for video
    $("#video_image").on "click", ->
      $("#player").removeClass("hidden")
      $("#player").css('display', 'block')
      $(this).hide()

    # if they are using the optional payment options section on the checkout page, need to conditional fix the email
    # field and button to the bottom of the page so it's displayed after selecting a radio button
    if $('.payment_options').length > 0

      onScroll = () ->
        wrapper = $('.checkout_controls_wrapper')
        if $(window).scrollTop() + $(window).height() < checkoutOffset
          wrapper.addClass('fix_to_bottom')
        else if wrapper.hasClass("fix_to_bottom")
          wrapper.removeClass('fix_to_bottom')

      $(window).on "scroll", ->
        onScroll()

      # the radio button selection should bring up the email field and button
      $('.payment_options ol li').on "click", ->
        return false if $(this).children(".payment_radio").attr("disabled") == "disabled"
        $(".payment_radio").parents("ol>li").removeClass("checkout_option_selected")
        $(this).addClass("checkout_option_selected")
        $(this).children(".payment_radio").attr "checked", "checked"
        onScroll()
        $('.checkout_controls_wrapper').addClass "checkout_ready"
$ ->
  Selfstarter.init()
  $("#email").focus() if $('.payment_options').length == 0
