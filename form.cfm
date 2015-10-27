<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>jQuery.post demo</title>
  <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
</head>
<body>
 
<form id="JqPostForm ">
  <input type="text" name="email_post " placeholder="Search...">
  <input type="submit" value="Search">
</form>
<!-- the result of the search will be rendered inside this div -->
<div id="message_post"></div>

 
<script>
$(function(){
    $("#JqPostForm").submit(function(){       
        $.post("map.cfm", $("#JqPostForm").serialize(),
        function(data){
            if(data.email_check == 'invalid'){
             
            $("#message_post").html("<div class='errorMessage'>Sorry " + data.name + ", " + data.email + " is NOT a valid e-mail address. Try again.</div>");
            } else {
                $("#message_post").html("<div class='successMessage'>" + data.email + " is a valid e-mail address. Thank you, " + data.name + ".</div>");
                }
        }, "json");
         
        return false;
         
    });
});

</script>
 
</body>
</html>