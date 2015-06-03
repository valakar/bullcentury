angular.module('bcApp').controller("ProjectController", function($scope, $http){
  $scope.profileImage='';
  $scope.profileCroppedImage='';
  $scope.rewardImage='';
  $scope.rewardCroppedImage='';

  $scope.init = function(id, user_id)
  {
    $scope.id = id;
    $scope.user_id = user_id;
    $http.get('/api/projects/' + $scope.id).success(function(data) {
      $scope.project = data;
      $scope.project.category_ids = returnValues($scope.project.categories);
      $scope.project.timeline_date1 = new Date(data.timeline_date1);
      $scope.project.timeline_date2 = new Date(data.timeline_date2);
      $scope.project.timeline_date3 = new Date(data.timeline_date3);
      $http.get('/api/cities/' + $scope.project.country_id).success(function(data) {
        $scope.cities = data;
      })
    })
    $http.get('/api/currencies/').success(function(data) {
      $scope.currencies = data;
    })
    $http.get('/api/countries/').success(function(data) {
      $scope.countries = data;
    })
    $http.get('/api/categories/').success(function(data) {
      $scope.categories = data;
    })
    $http.get('/api/profiles/' + $scope.user_id).success(function(data) {
      $scope.user = data;
    })
    $scope.tinymceOptions = {
      plugins: 'image link table hr media',
      toolbar: "undo redo styleselect bold italic print forecolor backcolor"
    };

  };

  $scope.change = function(id) {
    $http.get('/api/cities/' + id).success(function(data) {
      $scope.cities = data;
    })
  };
  $scope.saveMain = function() {
    var newProject = {
      name: $scope.project.name,
      funding_duration_in_days: $scope.project.funding_duration_in_days,
      funding_goal: $scope.project.funding_goal,
      video: $scope.project.video,
      category_ids: $scope.project.category_ids,
      currency_id: $scope.project.currency_id
    }  
    $http.put('/api/projects/' + $scope.id, {"project": newProject})
      .success(function(data){
        $.notify("Main part succesfully saved", "success");
      })
      .error(function(data){
        $.notify("Main part failed to be saved", "error");
      });
  };
  $scope.saveAuthor = function() {
    var newProject = {
      country_id: $scope.project.country_id,
      tweet: $scope.project.tweet,
      image: $scope.project.image
    }  
    var updateUser = {
      name: $scope.user.name,
      remote_image_url: $scope.profileCroppedImage
    };
    $http.put('/api/projects/' + $scope.id, {"project": newProject})
      .success(function(data){
        $.notify("Author part succesfully saved", "success");
      })
      .error(function(data){
        $.notify("Author part failed to be saved", "error");
      });
    $http.put('/api/profiles/' + $scope.user_id, {"user": updateUser})
      .success(function(data){
        $.notify("Profile succesfully updated", "success");
      })
      .error(function(data){
        $.notify("Profile failed to be updated", "error");
      });
  };
  $scope.editReward = function(reward){
    $scope.editing = true;
    $scope.newReward = reward;
    $scope.rewardImage='';
    $scope.rewardCroppedImage='';
    window.projectRewardForm.reset();
    $('html, body').animate({
        scrollTop: $("#projectRewardForm").offset().top
    }, 500);
  };
  $scope.clearForm = function(){
    $scope.editing = false;
    $scope.newReward = {};
    $scope.rewardImage='';
    $scope.rewardCroppedImage='';
    window.projectRewardForm.reset();
    $.notify("Form is cleared, you can add new reward now", "success");
  }
  $scope.updateReward = function() {
    console.log('UPDATE REWARD');
    $scope.newReward.remote_image_url = $scope.rewardCroppedImage;

    $http.put('/api/projects/' + $scope.id + '/rewards/' + $scope.newReward.id, {"reward": $scope.newReward})
        .success(function(data){

          //$scope.reward = data;
          $scope.newReward = {}; 
          $scope.rewardImage='';
          $scope.rewardCroppedImage='';

          window.projectRewardForm.reset();
          $scope.editing = false;
          $.notify("Reward succesfully updated", "success");
        })
        .error(function(data){
          $.notify("Reward failed to be updated", "error");
        });
  };
  $scope.saveReward = function() {
    console.log('SAVE REWARD');
    if ($scope.editing) {
        $scope.updateReward();
      } else {
        $scope.newReward.project_id = $scope.id;
        $scope.newReward.remote_image_url = $scope.rewardCroppedImage;
        console.log($scope.newReward);
        console.log($scope.newReward.remote_image_url);
        $http.post('/api/projects/' + $scope.id + '/rewards/', {"reward": $scope.newReward})
          .success(function(data){
            $scope.project.rewards.push(data);
            $scope.newReward = {};
            $scope.rewardImage='';
            $scope.rewardCroppedImage='';
            window.projectRewardForm.reset();
            $.notify("Reward succesfully saved", "success");
          })
          .error(function(data){
            $.notify("Reward failed to be saved", "error");
          });
      }
  };
  $scope.deleteReward = function(reward) {
      // $event.preventDefault();
      console.log('DELETE REWARD');
      console.log(reward);
      $http.delete('/api/projects/' + $scope.id + '/rewards/' + reward.id)
          .success(function ()
          {
              var index = $scope.project.rewards.indexOf(reward);
              $scope.project.rewards.splice(index,1);
              $.notify("Your reward succesfully deleted", "success");
          })
          .error(function (data)
          {
              $.notify("Reward failed to be deleted", "error");
          });
  };
  $scope.saveDetails = function() {
    var newProject = {
      description: $scope.project.description
    }  
    $http.put('/api/projects/' + $scope.id, {"project": newProject})
      .success(function(data){
        $.notify("Details part succesfully saved", "success");
      })
      .error(function(data){
        $.notify("Details part failed to be saved", "error");
      });
  };
  $scope.saveCreator = function() {
    var newProject = {
      website: $scope.project.website,
      creator_biography: $scope.project.creator_biography,
      country_id: $scope.project.country_id
    }  
    $http.put('/api/projects/' + $scope.id, {"project": newProject})
      .success(function(data){
        $.notify("Creator part succesfully saved", "success");
      })
      .error(function(data){
        $.notify("Creator part failed to be saved", "error");
      });
  };
  $scope.saveTimeline = function() {
    var newProject = {
      timeline1: $scope.project.timeline1,
      timeline2: $scope.project.timeline2,
      timeline3: $scope.project.timeline3,
      timeline_date1: new Date($scope.project.timeline_date1),
      timeline_date2: $scope.project.timeline_date2,
      timeline_date3: $scope.project.timeline_date3,
      name: $scope.project.name,
      country_id: $scope.project.country_id,
      city_id: $scope.project.city_id,
      region: $scope.project.region,
      zip: $scope.project.zip,
      address: $scope.project.address
    }  
    $http.put('/api/projects/' + $scope.id, {"project": newProject})
      .success(function(data){
        $.notify("Timeline part succesfully saved", "success");
      })
      .error(function(data){
        $.notify("Timeline part failed to be saved", "error");
      });
  };
  var returnValues = function(items){
        var arrayToReturn = [];
        for (var i=0; i<items.length; i++){
            arrayToReturn.push(items[i]['id']);
        }
        return arrayToReturn;
    };

  var handleFileSelect=function(evt) {
      var file=evt.currentTarget.files[0];
      var reader = new FileReader();
      reader.onload = function (evt) {
        $scope.$apply(function($scope){
          $scope.profileImage=evt.target.result;
        });
      };
      reader.readAsDataURL(file);
  };
  angular.element(document.querySelector('#profileImageInput')).on('change',handleFileSelect);
  var handleRewardFileSelect=function(evt) {
      var file=evt.currentTarget.files[0];
      var reader = new FileReader();
      reader.onload = function (evt) {
        $scope.$apply(function($scope){
          $scope.rewardImage=evt.target.result;
        });
      };
      reader.readAsDataURL(file);
  };
  angular.element(document.querySelector('#rewardImageInput')).on('change',handleRewardFileSelect);
});