angular.module('bcApp').controller("RewardController", function($scope, $http){
  $scope.init = function(id)
  {
    $scope.id = id;
    $http.get('/api/projects/' + $scope.id + '/rewards').success(function(data) {
      $scope.rewards = data;
    })
  };
  
  $scope.saveReward = function() {
    console.log('SAVE REWARD');
    if ($scope.editing) {
        console.log('EDIT');
        // $scope.updateProduct();
      } else {
        console.log('NEW');
        // $http.post('/api/projects/' + $scope.id + '/rewards', {reward: $scope.newReward})
        // .success(function(data) {
        //     $scope.rewards.push(data.reward);
        //     $scope.newReward = {};
        //     alert('Succesfully saved');

        // })
        // .error(function(data){
        //   alert('Failed to save');
        // });
        $scope.project.rewards.push(data.reward);
        
      }
  };
  // $scope.uploadFile = function(files) {
  //   var fd = new FormData();
  //   //Take the first selected file
  //   fd.append("file", files[0]);
  //   $scope.upload = files[0];
  //   console.log(files[0]);
  // };
  // $scope.saveAuthor = function() {
  //   console.log('SAVE AUTHOR');
  //   var newProject = {
  //     country: $scope.project.country,
  //     tweet: $scope.project.tweet,
  //     image: $scope.project.image
  //   }  
  //   var user;
  //   $http.put('/api/projects/' + $scope.id, {"project": newProject})
  //     .success(function(data){
  //       console.log();
  //       alert('Succesfully saved');
  //     })
  //     .error(function(data){
  //       alert('Failed to save');
  //     });
  // };
  // $scope.saveReward = function() {
  //   console.log('SAVE REWARD');
  // };
});