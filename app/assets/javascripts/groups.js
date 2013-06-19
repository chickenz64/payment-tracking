$(function(){

  var options = {
    title: "graph",
    shadowSize: 1, 
    HtmlText : false,
    grid : {
      verticalLines : false,
      horizontalLines : false
    },
    xaxis : { showLabels : false },
    yaxis : { showLabels : false },
    pie : {
      show : true, 
      explode : 2,
      lineWidth: 1,
    },
    mouse : { 
      track : true,
      lineColor: '#000'
    },
    legend : {
      position : 'sw',
      backgroundColor : '#D2E8FF'
    }
  };
  $("#highest-paid").click(function(){
    $("ul#graphs li").removeClass('active');
    $(this).parent().addClass('active');
    (function basic_pie(container) {
      var id = /groups\/([\w\d]+)/i.exec(window.location.pathname)[1];
      $.getJSON("/api/group_paid_sum/"+id+".json", function(data) {
        var mydata = [];
        $.each(data, function(i){ 
            mydata.push({ data: [[0, this.paid_sum]], label: this.name });
        });
        options['title'] = 'Most paid clients';
        Flotr.draw(container, mydata, options);
      });  
    })(document.getElementById("graph"));
  });
  $("#highest-profit").click(function(){
    $("ul#graphs li").removeClass('active');
    $(this).parent().addClass('active');
    (function basic_pie(container) {
      var id = /groups\/([\w\d]+)/i.exec(window.location.pathname)[1];
      $.getJSON("/api/group_profit/"+id+".json", function(data) {
        var mydata = [];
        $.each(data, function(i){ 
            mydata.push({ data: [[0, this.sum_profit]], label: this.name });
        });

        options['title'] = 'Highest profit clients';
        Flotr.draw(container, mydata, options);
      });  

    })(document.getElementById("graph"));  
    
  });
  $("#highest-remaining").click(function(){
    $("ul#graphs li").removeClass('active');
    $(this).parent().addClass('active');
    (function basic_pie(container) {
      var id = /groups\/([\w\d]+)/i.exec(window.location.pathname)[1];
      $.getJSON("/api/group_remaining/"+id+".json", function(data) {
        var mydata = [];
        $.each(data, function(i){ 
            mydata.push({ data: [[0, this.sum_remaining_amount]], label: this.name });
        });

        options['title'] = 'Highest remaining clients';
        Flotr.draw(container, mydata, options);
      });  
    })(document.getElementById("graph"));     
  });
  
});