<script>
$(".fancybox")
    .attr('rel', 'gallery')
    .fancybox({
        type: 'iframe',
        autoSize : false,
        beforeLoad : function() {                    
            this.width = parseInt(this.href.match(/width=[0-9]+/i)[0].replace('width=',''));  
            this.height = parseInt(this.href.match(/height=[0-9]+/i)[0].replace('height=',''));
        }
    });
</script>

<form id="frm-example" action="/nosuchpage" method="POST">   
<table id="example" class="display select" cellspacing="0" width="100%">
   <thead>
      <tr>
          <th><input name="select_all" value="1" type="checkbox"></th>
         <th>Campus</th>
         <th>District</th>
         <th>School Level</th>
         <th>Grade</th>
      </tr>
   </thead>
   <tfoot>
      <tr>
         <th></th>
         <th>Campus</th>
         <th>District</th>
         <th>School Level</th>
         <th>Grade</th>
      </tr>
   </tfoot>
   <tbody>
       <cfoutput query="qZipCode">
       <tr>
           <td>#id_number#</td>
           
           
           <td><a class="fancybox" href="compare.cfm?example_length=25&width=500&height=1200&id%5B%5D=#id_number#&id%5B%5D=2-57905058" title="#JSStringFormat(campus)# - #address#, #city#, #zip_code# - #phone# - #JSStringFormat(letter_grade)#">#JSStringFormat(campus)#</a></td>
           <td>#district#</td>
           <td>#school_level#</td>
           <td>#JSStringFormat(letter_grade)#</td>
       </tr>
        </cfoutput>   
      
   </tbody>
</table>

<p style="padding-left:50px" ><button>Compare</button></p>
    <a class="fancybox" href="" id="w3s"></a>
</form>

<script>
      
   // Array holding selected row IDs
   var rows_selected = [];
   var table = $('#example').DataTable({
       "oLanguage": {
        "sInfoEmpty": 'No schools to show',
        "sEmptyTable": "No schools found currently, please add at least one.",
       },
        "pageLength": 25,
      'columnDefs': [{
         'targets': 0,
         'searchable':false,
         'orderable':false,
         'className': 'dt-body-center',
         'render': function (data, type, full, meta){
             return '<input type="checkbox">';
         }
      }],
      'order': [1, 'asc'],
      'rowCallback': function(row, data, dataIndex){
         // Get row ID
         var rowId = data[0];

         // If row ID is in the list of selected row IDs
         if($.inArray(rowId, rows_selected) !== -1){
            $(row).find('input[type="checkbox"]').prop('checked', true);
            $(row).addClass('selected');
         }
      }
   });   

    // Handle click on checkbox
   $('#example tbody').on('click', 'input[type="checkbox"]', function(e){
      var $row = $(this).closest('tr');

      // Get row data
      var data = table.row($row).data();

      // Get row ID
      var rowId = data[0];
       
      // Determine whether row ID is in the list of selected row IDs 
      var index = $.inArray(rowId, rows_selected);

      // If checkbox is checked and row ID is not in list of selected row IDs
      if(this.checked && index === -1){
         rows_selected.push(rowId);

      // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
      } else if (!this.checked && index !== -1){
         rows_selected.splice(index, 1);
      }


      // Prevent click event from propagating to parent
      e.stopPropagation();
   });
    
     // Handle form submission event 
   $('#frm-example').on('submit', function(e){
      var form = this;
       
       

      // Iterate over all selected checkboxes
      $.each(rows_selected, function(index, rowId){
          
         // Create a hidden element 
         $(form).append(
             $('<input>')
                .attr('type', 'hidden')
                .attr('name', 'id[]')
                .val(rowId)
         );
      });

      // FOR DEMONSTRATION ONLY     
      
      // Output form data to a console     
      $('#example-console').text($(form).serialize());
      console.log("Form submission", $(form).serialize());
       var myLink = "/tsgv3/compare.cfm?width=1050&height=1200&" + $(form).serialize();
       
       $("#w3s").attr("href", myLink);
       $("#w3s").attr("class", "fancybox");
       $("#w3s")[0].click();
       //ProcessDialog(myLink);
       
      // Remove added elements
      $('input[name="id\[\]"]', form).remove();
       
      // Prevent actual form submission
      e.preventDefault();
   });
    
</script>
