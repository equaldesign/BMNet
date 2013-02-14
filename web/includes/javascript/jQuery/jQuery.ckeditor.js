$(document).ready(function(){
	$("textarea.editor").ckeditor(function(){
		
	},
	{
		skin: "chris",
		toolbar: "BMNet"
	}
	);
	$("textarea.editorAdvanced").ckeditor(function(){
    
  },
  {
    skin: "chris",
    toolbar: "Advanced"
  }
  );
	$("textarea.contacteditor").ckeditor(function(){
    
  },
  {
    skin: "chris",
    toolbar: "BMNetContact"
  }
  );
	$("textarea.simpleeditor").ckeditor(function(){
    
  },
  {
    skin: "chris",
    toolbar: "BMNetSimple"
  }
  );
})
