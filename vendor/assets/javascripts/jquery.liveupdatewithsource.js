jQuery.fn.liveUpdateWithSource = function(list, source, max){
  var that = this;
  jQuery.get(source).done(function( res ) { 
    list = $(list);
    var jsonData = res, ohtml = list.html();

    that.keyup(filter).keyup().parents('form').submit(function(){ return false; });

    return that;

    function filter(){
      var that2 = this;
      var term = jQuery.trim( jQuery(this).val().toLowerCase() ), scores = [], html = "", plans = "";
      if ( term ) {
        jQuery.each(jsonData, function(i){
          var score = this.name.toLowerCase().score(term);
          if (score > 0) { scores.push([score, i]);}
        });
        max = max || scores.length;
        jQuery.each(scores.sort(function(a, b){return b[0] - a[0];}), function(i){
          var obj = jsonData[this[1]];
          if(i < max ) {
            jQuery.each(obj.plan, function(i){
              plans += '<li><a href="/payment_plans/'+this.id+'/payments">'+this.product+'</a></li>';
            });
            html+='<tr><td><a href="/clients/'+obj.id+'" class="btn-link">'+obj.name+'</a></td>'+
            '<td><div class="btn-group">'+
            '<button class="btn btn-success dropdown-toggle" data-toggle="dropdown">Add Payment <span class="caret"></span></button>'+
            '<ul class="dropdown-menu">'+plans+'</ul>'+
            '</div></td>'+
            '<td><a href="/clients/'+obj.id+'/new_plan" class="btn btn-info">New Plan</a></td>';
            html+= obj.paid ? '<td></td></tr>' : '<td><span class="badge badge-important">&times;</span></td>';
          } 
          else { return; }
        });
        list.html(html);
      } else {
        list.html(ohtml);
      }
    }
  });
};