$(document).ready(function(){
  $('#login-form').submit(function(event){
    var legal_email = 'test@uetomae.co.jp';
    var legal_password = 'legal_password';
    if($('#login-email').val()==legal_email && $('#login-password').val()==legal_password){
      window.location.replace("/welcome.html");
    }else if($('#login-email').val()=='' || $('#login-password').val()==''){
      $('#error-message').empty().append('<div>Please enter your email and password.</div>');
    }else{
      $('#error-message').empty().append('<div>Invalid email/password. Please try again.</div>');
    }
    event.preventDefault();
  });

  $('input[name=uetomae-quiz]').change(function(){
    $('#uetomae-quiz-answer').html('');
  });
  $('#uetomae-quiz').submit(function(event){
    var answer = $('input[name=uetomae-quiz]:checked').val();
    var comment;
    if(typeof answer == 'undefined'){
      comment = "Hey, what's your opinion? Please select the one.";
    }else if(answer == 'a'){
      comment = 'No, <a href="https://goo.gl/rezkBu">her name</a> is not UETOMAE.';
    }else if(answer == 'b'){
      comment = 'You got it! Are you interested in joining UETOMAE? Please <a href="https://uetomae.co.jp/">contact us</a>.';
    }else if(answer == 'c'){
      comment = 'No, our founder is just two.';
    }
    $('#uetomae-quiz-answer').html(comment);
    event.preventDefault();
  });
});
