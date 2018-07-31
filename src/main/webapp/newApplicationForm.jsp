

<!--#################-->
<!-- EDIT MODAL FORM -->
<!--#################-->
<script src="utils.jsp"></script>
<script>
	function getLoadUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId")+"/applications/"+id;
	}
	function getSaveUrl(id){
		return Utils.SERVER+"/api/pathfinder/customers/"+Utils.getParameterByName("customerId")+"/applications/";
	}
	function getIdFieldName(){
		return "Id";
	}
</script>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
  <div class="modal-dialog" role="document"> <!-- make wider by adding " modal-lg" to class -->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="exampleModalLabel">New Application</h4>
      </div>
      <div class="modal-body">
        <form id="form">
        	<div id="form-id" class="form-group" style="display:none">
            <label for="Id" class="control-label">Customer Name:</label>
            <input id="Id" name="Id" type="text" class="form-control"/>
          </div>
          <div class="form-group">
            <label for="Name" class="control-label">Application Name:</label>
            <input id="Name" name="Name" type="text" class="form-control" onkeyup="validate()">
          </div>
          <div class="form-group">
            <label for="Stereotype" class="control-label">Application Profile:</label>
						<!--
						<select name="Stereotype" id="Stereotype" class="xform-control" onchange="validate()">
						-->
						
						<select name="Stereotype" id="Stereotype"  onchange="validate()">
							<option value="" selected disabled hidden>Choose...</option>
							<option value="TARGETAPP" selected>Assessable Application</option>
							<option value="DEPENDENCY">Dependency Only (ie. database or LDAP Server)</option>
							<!--option value="PROFILE">Profile</option-->
						</select>
          </div>
          <div class="form-group">
            <label for="Description" class="control-label">Application Description:</label>
            <input id="Description" name="Description" type="text" class="form-control">
          </div>
        </form>
      </div>
      <script>
      function validate(){
        console.log("Stereotype="+$('#Stereotype').val());
        console.log("Name="+$('#Name').val());
	      $('#edit-ok').attr('disabled', isEmpty($('#Stereotype').val()) || isEmpty($('#Name').val()))
      }
      function isEmpty(val){
      	return val==null || val=="";
      }
      
      console.log("Do something...");
      $('Stereotype').val("TARGETAPP");
      $('Stereotype').attr("value", "TARGETAPP");
      
      var country = document.getElementById("Stereotype");
			country.options[country.options.selectedIndex].selected = true;

      
      </script>
      
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button id="edit-ok" type="button" data-dismiss="modal" disabled onclick="save('form'); return false;">Create</button>
      </div>
    </div>
  </div>
</div>