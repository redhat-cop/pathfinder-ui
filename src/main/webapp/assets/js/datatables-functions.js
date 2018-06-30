function send(action, uri, data){
  var xhr = new XMLHttpRequest();
  var ctx = "${pageContext.request.contextPath}";
  //var url=ctx+"/api"+uri;
  var url=uri;
  
  xhr.open(action, url, true);
  if (data != undefined){
    xhr.setRequestHeader("Content-type", "application/json");
    console.log("send data = "+JSON.stringify(data));
    xhr.send(JSON.stringify(data));
  }else{
    xhr.send();
  }
  xhr.onloadend = function () {
  	//var table1=$('#example').DataTable();
  	//var oSettings=table1.fnSettings();
  	//console.log("table="+JSON.stringify(table1));
  	//console.log("oSettings="+JSON.stringify(oSettings));
  	
  	$('#example').DataTable().ajax.reload(
  		function(json){
  		  // ideally we'd just call fnInitComplete but sadly i can't find that function embedded in the datatable object yet
  			onDatatableRefresh(json);
  			//table.fnSettings.fnInitComplete(null, json);
  		}
  	);
  	
    //$('#example').dataTable().ajax.reload();// new function(json){console.log("json="+json);}, true );
    //$('#example').dataTable().fnReloadAjax(null, onDatatableRefresh, null);
//    if (undefined!=postAction){
//    	postAction();
//    }
  };
}

function afterRefresh(json){
	console.log("afterRefresh: "+json);
}

function post(uri, data){
  return send("POST", uri, data);
}
function postWait(url, data, callback){
	var xhr = new XMLHttpRequest();
	xhr.open("POST", url, true);
	xhr.setRequestHeader("Content-type", "application/json");
	xhr.send(JSON.stringify(data));
	xhr.onloadend = function () {
	  callback(xhr.responseText);
	};
}

function deleteItem(id){
	if (!confirm("Are you sure?")){
		return false;
	}else{
  	httpDelete(Utils.SERVER+"/api/pathfinder/customers/"+id);
	}
}

function httpDelete(uri, data){
  return send("DELETE", uri, data);
}
function put(uri, data){
  return send("put", uri, data);
}
function editFormReset(){
    document.getElementById("edit-ok").innerHTML="Create";
    document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("Update", "New");
    
    var form=document.getElementById("form");
    for (var i = 0, ii = form.length; i < ii; ++i) {
      var input = form[i];
      input.value="";
    }
    
    if (null==document.getElementById(getIdFieldName())){
      console.log("Unable to find element named: "+getIdFieldName());
    }
    document.getElementById(getIdFieldName()).value="NEW";
}
function loadEntity(id){
  document.getElementById("edit-ok").innerHTML="Update";
  document.getElementById("exampleModalLabel").innerHTML=document.getElementById("exampleModalLabel").innerHTML.replace("New", "Update");
  var xhr = new XMLHttpRequest();
  var ctx = "${pageContext.request.contextPath}";
  xhr.open("GET", getLoadUrl(id), true);
  //xhr.open("GET", SERVER+"/api/pathfinder/customers/"+id+"/", true);
  xhr.send();
  xhr.onloadend = function () {
    var json=JSON.parse(xhr.responseText);
    var form=document.getElementById("form");
    for (var i = 0, ii = form.length; i < ii; ++i) {
      if (typeof json[form[i].name] == "undefined"){
        form[i].value="";
      }else{
        form[i].value=json[form[i].name];
      }
    }
  }
}
function save(formId){
  var data = {};
  var op="";
  var form=document.getElementById(formId);
  for (var i = 0, ii = form.length; i < ii; ++i) {
    if (form[i].name) data[form[i].name]=form[i].value;
  }
  post(getSaveUrl(), data);
  //post(SERVER+"/api/pathfinder/customers/", data);
  editFormReset();
}

function httpGet(url, field, callback){
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.send();
	xhr.onloadend = function () {
	  callback(JSON.parse(xhr.responseText)[field]);
	};
}

function httpGetObject(url, callback){
	var xhr = new XMLHttpRequest();
	xhr.open("GET", url, true);
	xhr.send();
	xhr.onloadend = function () {
	  callback(JSON.parse(xhr.responseText));
	};
}


