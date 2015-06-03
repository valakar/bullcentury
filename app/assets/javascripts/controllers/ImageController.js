angular.module('bcApp').controller("ImageController", function($scope, $http) {
    $scope.myImage='';
    $scope.myCroppedImage='';

    var handleFileSelect=function(evt) {
      var file=evt.currentTarget.files[0];
      var reader = new FileReader();
      reader.onload = function (evt) {
        $scope.$apply(function($scope){
          $scope.myImage=evt.target.result;
        });
      };
      reader.readAsDataURL(file);
    };
    angular.element(document.querySelector('#fileInput')).on('change',handleFileSelect);

    $scope.saveImage = function() {
	    var newProject = {
	      remote_image_url: $scope.myCroppedImage
	    }  
	    $http.put('/api/projects/' + $scope.id, {"project": newProject})
	      .success(function(data){
	        $.notify("Image succesfully saved", "success");
	      })
	      .error(function(data){
	        $.notify("Image failed to be saved", "error");
	      });
	  };
  });
