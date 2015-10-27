
   

<html>
<head>
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    
    
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
        
      function drawVisualization() {
    // Create and populate the data table.
    var data = google.visualization.arrayToDataTable([
        ['Task', 'Hours per Day'],
        ['Work', 11],
        ['Eat', 2],
        ['Commute', 2],
        ['Watch TV', 2],
        ['Sleep', 7]
        ]);

    // Create and draw the visualization.
    var chart = new google.visualization.PieChart(document.getElementById('visualization'));
    google.visualization.events.addListener(chart, 'ready', allReady); // ADD LISTENER
    chart.draw(data, {title:"So, how was your day?"});
}

function allReady() {
    var e = document.getElementById('visualization');
    // svg elements don't have inner/outerHTML properties, so use the parents
    var svg = e.getElementsByTagName('svg')[0].parentNode.innerHTML;
    var c = document.getElementById('subscriber-value');
    c.value = svg;
    //alert(e.getElementsByTagName('svg')[0].parentNode.innerHTML);
    
     $(document).ready(function(){
     $("button").click(function(){
        
        $.post("post.cfm",
        {
          name: svg,
          city: "Duckburg"
        },
        function(data,status){
            //alert("Data: " + data + "\nStatus: " + status);
        });
    });
});
    
}

google.setOnLoadCallback(drawVisualization);
        
     
        
        
        
    </script>
    

    
    </head>
    <body>
        

<button>Send an HTTP POST request to a page and get the result back</button>
        
            
    <input id="subscriber-value" name="foo">
        
        

        
                <div id="visualization" style="width: 250px; height: 250px;"></div> AW BROWN-F L A  <br /> School ID Number = 1-57816101     
    </body>
</html>    