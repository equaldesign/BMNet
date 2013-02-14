// ActionScript Document
var appointmentID = <cfoutput>#rc.id#</cfoutput>;

var selectedFileSize = 0;
var selectedFileType = "";


function applyFilter( term:String, grid:mx.controls.DataGrid, columns:Array ):Void {
   var filterTerm:String = term.toString().toLowerCase();
   if(filterTerm.length > 0) {
      if(_global.unfilteredData[grid.id] == undefined){
         if (_global.unfilteredData == undefined){
            _global.unfilteredData = {};
         }
         _global.unfilteredData[grid.id] = grid.dataProvider.slice(0);
      }
      var filteredData:Array = [];
      for(var i = 0; i< _global.unfilteredData[grid.id].length; i++) {
         var item:Object = _global.unfilteredData[grid.id][i];
         var added:Boolean = false;
         
         for(var j = 0; j< columns.length; j++){
             if(!added){
               var value:String = item[columns[j]].toString().toLowerCase();
               if(value.indexOf(filterTerm) != -1)   {
                  filteredData.push(item);
                  added = true;
               }
            }
            else {
               break;
            }
         }
      }
   grid.dataProvider = filteredData;
   }
   else {
      if(_global.unfilteredData[grid.id] != undefined) grid.dataProvider = _global.unfilteredData[grid.id];
   }
}

function onLoader():Void {
		if (_root.appointmentID != 0) {
			_root.next5.label = "edit this >";	
		}
		if (appointmentID == 0) {
			var title = "Create Meeting/Event";
		} else {
			var title = "Edit Meeting/Event";
		}		
		contacts.dragEnabled=true;
		contacts.multipleSelection = true;			
		contacts.addEventListener('dragEnter', doDragEnterSource);
		contacts.addEventListener('dragOver', doDragOverSource);
		contacts.addEventListener('dragExit', doDragExitSource);
		contacts.addEventListener('dragDrop', doDragDropDGSource);
		contacts.addEventListener('dragComplete', doDragCompleteDGSource);    
		
		groups.dragEnabled=true;
		groups.multipleSelection = true;			
		groups.addEventListener('dragEnter', doDragEnterSource);
		groups.addEventListener('dragOver', doDragOverSource);
		groups.addEventListener('dragExit', doDragExitSource);
		groups.addEventListener('dragDrop', doDragDropDGSource);
		groups.addEventListener('dragComplete', doDragCompleteDGSource);    		
		
		invitedContacts.dragEnabled=true;
		invitedContacts.multipleSelection = true;						
		invitedContacts.addEventListener('dragEnter', doDragEnterDest);
		invitedContacts.addEventListener('dragOver', doDragOverDest);
		invitedContacts.addEventListener('dragExit', doDragExitDest);
		invitedContacts.addEventListener('dragDrop', doDragDropDGDest);
		invitedContacts.addEventListener('dragComplete', doDragCompleteDGDest);




		_global.listOrig = '';	
		var grdDestListener:Object = {};	
		grdDestListener.mouseDown = function() {
			_global.listOrig = 'contacts'; 
		}
		invitedContacts.addEventListener("mouseDown", grdDestListener); 
		
		
		var grdSourceListener:Object = {};
		grdSourceListener.mouseDown = function() {
			_global.listOrig = 'invitedContacts'; 
		}
		contacts.addEventListener("mouseDown", grdSourceListener); 
		



		//Reference the grids
		var listSource:Object = {};
		var listDestination:Object = {};
		
		//destination grid focus listener
		var grdDestListener:Object = {};
		var grdSourceListener:Object = {};
		
		//destination select focus listener
		
		//Specify source and target flags
		var overSourceItem:Boolean = false;
		var overTargetItem:Boolean = false;
		
		var alreadyDraggedOver:Boolean = false;
		var alreadyEnter:Boolean = false;	
		var currentGrid:String = "";

		//functions declared in formOnload to avoid _root prefix		
		function doDragEnterSource(event) {
			alreadyEnter = true;
			listSource = event.target;
			event.handled = true;	
		}
			
		function doDragEnterDest(event) {
			alreadyEnter = true;
			listDestination = event.target;	
			event.handled = true;	
		}	
					
		function doDragExitSource(event) {
			listSource = event.target;
			overSourceItem = false;
			event.target.hideDropFeedback();
		}
		
		function doDragExitDest(event) {
			listDestination = event.target;	
			overTargetItem = false;
			event.target.hideDropFeedback();
		}
		
		function doDragOverSource(event) {
			listSource = event.target;				
			currentGrid = String(listSource);
			var gridArray:Array = currentGrid.split(".");
			currentGrid = gridArray[gridArray.length - 1];
			
			if (listDestination.dataProvider.length > 0) {
				overSourceItem = true;
				event.target.showDropFeedback();
				if (Key.isDown(Key.CONTROL)) {
					event.action = mx.managers.DragManager.COPY;
				} else if (Key.isDown(Key.SHIFT)) {
					event.action = mx.managers.DragManager.LINK;
				} else {
					event.action = mx.managers.DragManager.MOVE;
				}
			} 
			
		}
		
		function doDragOverDest(event) {
					listDestination = event.target;	
			alreadyDraggedOver = true;								
			currentGrid = String(listDestination);
			var gridArray:Array = currentGrid.split(".");
			var dontDrop:Boolean = false;
			currentGrid = gridArray[gridArray.length - 1];
			
			var itemAlreadyExists:Boolean = false;
			//handle grid actions
			if (currentGrid == "invitedContacts")
			{
				//loop based on greater/lesser lengths
				if(listDestination.length > listSource.selectedItems.length)
				{
					for (var i = 0; i < listDestination.length; i++)
					{
						if (!itemAlreadyExists)
						{
							for (var x = 0; x < listSource.selectedItems.length; x++)
							{	
								if (listSource.selectedItems.getItemAt(x).id == listDestination.getItemAt(i).id)
								{
								   itemAlreadyExists = true;
								   break;
								}
							}
						}	
						else
						{
							break;
						}
					}
				}
				else
				{
					for (var i = 0; i < listSource.selectedItems.length; i++)
					{
						if (!itemAlreadyExists)
						{						
							for (var x = 0; x < listDestination.length; x++)
							{									
								if (listDestination.getItemAt(x).id == listSource.selectedItems.getItemAt(i).id)
								{
								   itemAlreadyExists = true;
								   break;
								}
							}
						}	
						else
						{
							break;
						}	
					}		
				}	
				
				if (alreadyDraggedOver && alreadyEnter)
				{					    													
					if (itemAlreadyExists && _global.listOrig == 'invitedContacts')
					{
						alert('Item already added check selection.', "Warning");
					}
				}	
			}
			
			if (listSource.length > 0 and !itemAlreadyExists)	{
					overTargetItem = true;
					event.target.showDropFeedback();
					if (Key.isDown(Key.CONTROL)) {
						event.action = mx.managers.DragManager.COPY;
					} else if (Key.isDown(Key.SHIFT)) {
						event.action = mx.managers.DragManager.LINK;
					} else {
						event.action = mx.managers.DragManager.MOVE;
					}
			}
			alreadyEnter = false;						
		}
				
		function doDragDropDGSource(event) {
			doDragExitDest(event);
			var dragItems = event.dragSource.dataForFormat('items');
			var dest = event.target;
			var dropLoc = dest.getDropLocation();
			dest.addItemsAt(dropLoc,dragItems);			
		}
		
		function doDragDropDGDest(event) {			
			doDragExitSource(event);
			var dragItems = event.dragSource.dataForFormat('items');
			var dest = event.target;
			var dropLoc = dest.getDropLocation();
			dest.addItemsAt(dropLoc,dragItems);				
		}
		
		function doDragCompleteDGSource(event){
			var dest = event.target;
			var action = event.action;
			var dropLoc = dest.getDropLocation();
			var doDrop = false;
			var selectedIn:Array = event.target.selectedIndices;
			var groupIDsToDrop:Array = event.target.selectedIndices;
			
			//descending sort to remove items that have been dropped into target grid
			selectedIn.sort(16|2);
			
			if (overTargetItem)
			{
				for(var i = 0; i < selectedIn.length; i++){
					//add the selected items
					if (event.target.selectedItems[i].groupname != undefined) {
						doDrop = true;
					}					
						listDestination.dataProvider.addItem(event.target.selectedItems[i]);
						listDestination.selectedIndex = -1;
				}
				if (action == "move") {
					for(var i = 0; i < selectedIn.lengt; i++){
						//remove this item
						event.target.dataProvider.removeItemAt(selectedIn[i]);
					}
				}
				
				if (event.target.dataProvider.length == 0)
				{
					event.target.dataProvider.removeAll();					
				}
				event.target.selectedIndex = 0; 
				listDestination.selectedIndex = 0;
			}	
			overTargetItem = false;
			listDestination.hideDropFeedback();
			listSource = event.target;	
			if (doDrop) {
				_root.getContactsFromGroup();
			}
		}
		
		function doDragCompleteDGDest(event){
			var dest = event.target;
			var action = event.action;
			var dropLoc = dest.getDropLocation();
			var selectedIn:Array = event.target.selectedIndices;
		
			//descending sort to remove items that have been dropped into target grid
			selectedIn.sort(16|2);				
			if (!overTargetItem) {
				for(var i = 0; i < selectedIn.length; i++){
					//add the selected items 
					listSource.dataProvider.addItem(event.target.selectedItems[i]);
				}
				if (action == "move") {
						for(var i = 0; i < selectedIn.length; i++){
							//remove this item 
							event.target.dataProvider.removeItemAt(selectedIn[i]);															
						}
				}
				
				if (event.target.dataProvider.length == 0) {
					event.target.dataProvider.removeAll();					
				}
				listSource.selectedIndex = 0;
				event.target.selectedIndex = 0;
			}
			alreadyDraggedOver = false;
			alreadyEnter = false;
			overSourceItem = false;		
			listSource.hideDropFeedback();
			_global.listOrig = '';																		
			_global.nongroupawardAdd();	
			listDestination = event.target;		
		}		
}	

function addContactsTorecipients(dataset) {
	for (var i=0;i < dataset.length; i++) {
			_root.invitedContacts.insertRow(dataset[i]);
	}
}

function getContactsFromGroup() {
		var invitedContacts = invitedContacts;
		mx.managers.CursorManager.setBusyCursor();
		//create connection
		<cfoutput>
		var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
		</cfoutput>
		//declare service
		var myService:mx.remoting.NetServiceProxy;
		var responseHandler = {};
		responseHandler.onResult = function( results: Object ):Void {
			mx.managers.CursorManager.removeAllCursors();
			invitedContacts.removeAll();
			invitedContacts.dataProvider = results._items;
		}
		responseHandler.onStatus  = function( stat: Object ):Void {
			alert("Error while calling cfc:" + stat.description);
		}
		myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({
      event: "groups.getChildContacts",
      groupID: _root.invitedContacts.dataProvider,
			hideNoEmail: "true"
	  });     

		
}

function removeContacts() {
	var invitedContacts = invitedContacts;
	var selectedIn:Array = invitedContacts.selectedIndices;
	var id = id.text;
	for(var i = 0; i < selectedIn.length; i++){
		// remove this item 
		 invitedContacts.dataProvider.removeItemAt(selectedIn[i])
		 
	}
	mx.managers.CursorManager.setBusyCursor();
    //create connection
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
    //declare service
    var myService:mx.remoting.NetServiceProxy;
    var responseHandler = {};
    responseHandler.onResult = function( results: Object ):Void {
     mx.managers.CursorManager.removeAllCursors();     
    }
    responseHandler.onStatus  = function( stat: Object ):Void {
      alert("Error while calling cfc:" + stat.description);
    }
    myService = connection.getService("remote.MyProxy", responseHandler );  
    myService.process({
        event: "calendar.removeUsers",
        id: id,
        attendeeList: invitedContacts.dataProvider
      });
}


function createAppointment() {
  var notify = whotonotify.selectedItem.data;
  var attendeeList = invitedContacts.dataProvider;
  var subject = subject.text; 
  var template = template.text;
    <cfoutput>
    var connection:mx.remoting.Connection = mx.remoting.NetServices.createGatewayConnection("http://#cgi.HTTP_HOST#/flashservices/gateway/");
    </cfoutput>
  var myService:mx.remoting.NetServiceProxy;
  var responseHandler = {};
  var id = id.text;
      mx.managers.CursorManager.setBusyCursor();
      responseHandler.onResult = function(results:Object ):Void {
        mx.managers.CursorManager.removeAllCursors();
        alert("Invites sent");

      }
      responseHandler.onStatus  = function( stat: Object ):Void {
        alert("Error while calling cfc:" +stat.description+chr(13)+'Error Code: '+stat.code+chr(13)+'Error Details: '+stat.details+chr(13)+'Error Level: '+stat.level+chr(13)+'Error Line: '+stat.line);
      }
			myService = connection.getService("remote.MyProxy", responseHandler );  
	    myService.process({
	      event: "calendar.doEditList",
	      id: id,
				attendeeList: attendeeList,
				subject: subject,
				template: template,
				notify: notify
	    });                  
}






