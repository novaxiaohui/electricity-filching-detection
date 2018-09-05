<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>窃电用户检测系统</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">

<%@ include file="/page/common_import.jsp"%>
<%
	String workFilePath = (String) session
			.getAttribute("workFilePosition");
	String allUserType = (String) session
			.getAttribute("allUserTypeRelativePath");
%>
<script src="<%=path%>/plugins/loding/loding.js"></script>
<link rel="stylesheet" href="<%=path%>/plugins/loding/loding.css">
<style>
.main-header .navbar {
	-webkit-transition: margin-left .3s ease-in-out;
	-o-transition: margin-left .3s ease-in-out;
	transition: margin-left .3s ease-in-out;
	margin-bottom: 0;
	margin-left: 0px;
	min-height: 97px;
	border: none;
	border-radius: 0;
	background: 	
	URL(<%=path%>/img/login/banner.png) no-repeat,
	url(<%=path%>/img/main/titlebg.png) 100% 100% ;	   
}

.content-wrapper {
	min-height: 100%;
	background: URL(<%=path%>/img/main/bg.png);
	background-color: #6761c6;
	background-size:cover; 
	background-repeat: no-repeat;
	z-index: 800;
}

.content>.row:nth-child(1)>.col-md-2.col-sm-6 {
	width: 20%;
}

.content>.row:nth-child(1)>.col-md-1.col-sm-6 {
	width: 6.6666667%;
}
.logout{
    position: absolute;
    top: 70px;
    right: 20px;
    color: #fff;
    }
.back{
position: absolute;
    top: 70px;
    right: 70px;
    color: #fff;
}
.content>.row:nth-child(1)>.col-md-1.col-sm-6>div {
	margin: 35px auto;
}

.box {
	position: relative;
	border-radius: 3px;
	background: #ffffff;
	border-top: 0px;
	margin-bottom: 20px;
	width: 100%;
	box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
}

.box_body {
	height: 150px;
	width: calc(100% -             0px);
	background: #f1edf9;
	margin-bottom: 20px;
	box-shadow: 5px 5px 5px #3c3757;
	border-radius: 6px 6px;
}

.box_title_1 {
	height: 50px;
	width: calc(100% -             0px);
	background: #9387f5;
	border-radius: 6px 6px 0px 0px;
	text-align: center;
	font-size: 30px;
	color: #ffffff;
	font-weight: bold;
	padding-top: 2px;
}

.box_title_2 {
	height: 50px;
	width: calc(100% -             0px);
	background: #d9d3df;
	border-radius: 6px 6px 0px 0px;
	text-align: center;
	font-size: 30px;
	color: #9387f5;
	font-weight: bold;
	padding-top: 2px;
}

.label_1 {
	font-size: 24px;
	font-weight: bold;
	margin-left: 10px;
}

@media screen and (min-width: 1199px) and (max-width: 1921px) {
	.label_2 {
		font-size: 24px;
		font-weight: bold;
	}
}

@media screen and (min-width: 1921px) and (max-width: 2049px) {
	.label_2 {
		font-size: 20px;
		font-weight: bold;
	}
}

.line_0{
	background: #322c4c;
	text-align: center;
	font-size: 25px;
	color: #c1becb;
	font-weight: bold;
	border-radius: 6px 6px 6px 6px;
	padding:10px;
	width:30%;
	margin-left:5%;
	float:left;
}

.line_0:first-child{
	margin-left:0px;
}

.line_0 span{
	font-size: 25px;
	color:#ff7f15;
}

.line_1 {
	background: #322c4c;
	text-align: center;
	font-size: 25px;
	color: #c1becb;
	font-weight: bold;
	border-radius: 6px 6px 0px 0px;
	margin-left: 15px;
	width: calc(100% -             30px);
}

.pie_1 {
	background: #424066;
	text-align: center;
	font-size: 22px;
	color: #b9b4c1;
	font-weight: bold;
	border-radius: 6px 0px 0px 6px;
	width: 60px;
	height: 350px;
	float: left;
}

.qdButton {
	margin: 8px auto;
}

.box .labelClass{
	padding-left:10px;
	color:#fff;
}

.pagination-info,.page-list{
	color:#fff;
}

#btn_print{
    background-color: #ff7f15;
    border: none;
    padding: 10px;
    color: #fff;
    margin-left: 10px;
    float: left;
    position: absolute;
    left: 5px;
    z-index:1;
    display:none;
 }
</style>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">
		<header class="main-header">
			<nav class="navbar"></nav>
			<div id="bannerDiv">
		    	<a href="#" onclick="logout()" class="logout">退出</a>
		    	<a href="fileUpload.jsp" class="back">返回</a>
		    </div>
		</header>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">

			<!-- Main content -->
			<section class="content">
		<%-- 		<div class="row">
					<div class="col-md-2 col-sm-6 col-xs-12">
						<div class="box_body col-md-12">
							<div class="row">
								<label class="box_title_1">数据量</label>
							</div>
							<div class="row">
								<label class="label_1">用户总数：</label><label id="sjl_yhzs"
									class="label_2"></label>
							</div>
							<div class="row">
								<label class="label_1">数据总数：</label><label id="sjl_sjzs"
									class="label_2"></label>
							</div>
						</div>
					</div>

					<div class="col-md-1 col-sm-6 col-xs-12">
						<div>
							<img src="<%=path%>/img/main/triangle.png" />
						</div>
					</div>

					<div class="col-md-2 col-sm-6 col-xs-12">
						<div class="box_body col-md-12">
							<div class="row">
								<label class="box_title_2">用电量聚类</label>
							</div>
							<div class="row">
								<label class="label_1" style="padding-top:20px;">聚类总类：</label><label
									id="ydljl_jlzl" class="label_2"></label>
							</div>
						</div>
					</div>

					<div class="col-md-1 col-sm-6 col-xs-12">
						<div>
							<img src="<%=path%>/img/main/triangle.png" />
						</div>
					</div>

					<div class="col-md-2 col-sm-6 col-xs-12">
						<div class="box_body col-md-12">
							<div class="row">
								<label class="box_title_1">用电行为聚类</label>
							</div>
							<div class="row">
								<label class="label_1" style="padding-top:20px;">用电行为聚类：</label><label
									id="ydxwjl_jlzl" class="label_2"></label>
							</div>
						</div>
					</div>

					<div class="col-md-1 col-sm-6 col-xs-12">
						<div>
							<img src="<%=path%>/img/main/triangle.png" />
						</div>
					</div>

					<div class="col-md-2 col-sm-6 col-xs-12">
						<div class="box_body col-md-12">
							<div class="row">
								<label class="box_title_2">结论</label>
							</div>
							<div class="row">
								<label class="label_1" style="padding-top:20px;">疑似违约用户：</label><label
									id="jl_yswyyh" class="label_2"></label>
							</div>
						</div>
					</div>
				</div> --%>

				<div class="row">
					<div class="col-md-12">
						<div class="row" style="padding:15px;">
							<div class="line_0" >
								<lable>用户总数</lable>
								<span id="user_num">35462</span>
							</div>
							<div class="line_0">
								<lable>嫌疑用户数</lable>
								<span id="thief_num">35462</span>
							</div>
							<div class="line_0">
								<lable>台区总数</lable>
								<span id="zone_num">35462</span>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12 line_1">
								<lable>用户占比</lable>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
								<div id="ydl_line" class="box"
									style="width: calc(100% - 0px);height:400px;"></div>
							</div>
						</div>
					</div>
					<!-- <div class="col-md-6">
						<div class="row">
							<div class="col-md-12 line_1">
								<lable>用电行为聚类曲线</lable>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								为 ECharts 准备一个具备大小（宽高）的 DOM
								<div id="ydxw_line" class="box"
									style="width: calc(100% - 0px);height:400px;"></div>
							</div>
						</div>
					</div> -->
				</div>

				<!-- <div class="row">
					<div class="col-md-4">
						<div class="pie_1" style="padding:20px;">
							<lable>用电量统计占比</lable>
						</div>
						为 ECharts 准备一个具备大小（宽高）的 DOM
						<div id="ydl_pie"
							style="width: calc(100% - 60px);height:350px;float:left;"></div>
					</div>
					<div class="col-md-4">
						<div class="pie_1" style="padding:20px;">
							<lable>用电行为占比</lable>
						</div>
						为 ECharts 准备一个具备大小（宽高）的 DOM
						<div id="ydxw_pie" class="box"
							style="width: calc(100% - 60px);height:350px;float:left;"></div>
					</div>
					<div class="col-md-4">
						<div class="pie_1" style="padding-left:10px;padding-right:10px;">
							<lable>疑似窃电违约占比</lable>
						</div>
						为 ECharts 准备一个具备大小（宽高）的 DOM
						<div id="ysqdwy_pie" class="box"
							style="width: calc(100% - 60px);height:350px;float:left;"></div>
					</div>
				</div> -->

				<div class="row">
					<div class="col-md-12">
						<div class="row">
							<div class="col-md-12">
								<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
								<div class="box"
									style="width: calc(100% - 0px);height:495px;padding:10px;background-color:#424066;">

									<div class="row" id="customToop" style="display: none;">
										<div class="col-md-12">
											<span id="ydl_chexk_box" style="color:#fff">用电量聚类类别：</span> <span
												id="ydxw_chexk_box" style="color:#fff">用电行为聚类类别：</span>

											<button type="button" class="btn" onclick="diyfenxi()">自定义分析</button>
										</div>
									</div>

									<div class="row">
										<div><input type="button" value="查看用电量曲线" name="sss" id="btn_print"/></div>
										<div class="col-md-12">
											<table id="ydTable" style="background-color:#d6b5f9"
												data-toggle="table">
											<%-- 	<div class="qdButton pull-left">
													<form id="form1">
														<button type="button" onclick="downfile(1)" class="btn">异动工单下载</button>
													</form>
													<a href="<%=allUserType%>"><button type="button"
															class="btn">所有用户曲线类型下载</button> </a> <a href="#"><button
															type="button" onclick="showDiyfenxi()" class="btn">自定义分析...</button>
													</a>
												</div> --%>
												<thead style="background-color:#d6b5f9">
													<tr>
														<!-- <th data-field="tqbh" data-sortable="true">台区编号</th> -->
														<th data-field="xzk">选择</th>
                                                    	<th data-field="user_elec"></th>
														<th data-field="zone_name" data-sortable="true">台区名称</th>
														<!-- <th data-field="dq">地区</th> -->
														<th data-field="station" data-sortable="true">供电所</th>
														<!-- <th data-field="dbbh">电表编号</th> -->
														<th data-field="user_id" data-sortable="true">用户编号</th>
														<th data-field="user_name" data-sortable="true">用户名称</th>
														<th data-field="address" data-sortable="true">用电地址</th>
														<th data-field="prop" data-sortable="true">窃电嫌疑系数</th>														
													</tr>
												</thead>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

			</section>
		</div>

		<div id="ydlModal" class="modal fade bs-example-modal-lg"
			tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
			<div class="modal-dialog modal-lg" role="document" style="">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" style="text-align: center;font-size: 24px;">用电量查看</h4>
					</div>
					<div class="modal-body">
						<div id="ydl_line_Modal" class="box"></div>
					</div>

				</div>
			</div>
		</div>
		
		
		<!-- ./wrapper -->

	<script>
	
	function logout(){
      	$.ajax({
			url: '<%=path%>' + "/loginAction/loginOut.do",
			dataType : "json", // 返回格式为json
			async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
			type : "post", // 请求方式，查询
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			success : function(data) 
			{
	            console.log(data);
			    if(data.resultCode == "200")
			    {
			         window.location.href="<%=path%>";
			    }
			    else 
			    {
			        showErrorMsg(data.msg);
			    }
			    
                 
			},
			complete : function() {
				hideLoading();
			}
		}); 
      }
	$(function(){
	
		callRAnalysis();
		getScreenWidthHeight();
		
		$("#btn_print").click(function(){
			var a= $("#ydTable").bootstrapTable('getSelections');
			if(a.length < 1){
				alert("请选择需要查看的用户");
			}else{
				ydxwLine(a);
				
				
				$("#ydlModal").modal();
			}
        });
	})
	
	var global_ydljl_line;
	
	function getScreenWidthHeight(){
		var winHeight;
		var winWidth;
			// 获取窗口宽度
			if (window.innerWidth){
				winWidth = window.innerWidth;
			}
			else if ((document.body) && (document.body.clientWidth)){
				winWidth = document.body.clientWidth;
			}
			// 获取窗口高度
			if (window.innerHeight){
				winHeight = window.innerHeight;
			}
			else if ((document.body) && (document.body.clientHeight)){
				winHeight = document.body.clientHeight;
			}
			// 通过深入 Document 内部对 body 进行检测，获取窗口大小
			if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth)
			{
				winHeight = document.documentElement.clientHeight;
				winWidth = document.documentElement.clientWidth;
			}
			
			$("#ydlModal .modal-lg").width(winWidth-200);
			$("#ydlModal .modal-lg").height(winHeight-200);
			$("#ydl_line_Modal").width(winWidth-220);
			$("#ydl_line_Modal").height(winHeight-220);
	}
	
	//调R语言进行分析
	function callRAnalysis() {  
     	$.ajax({  
         	url: '<%=path%>/callRAction/callRAnalysis.do' ,  
         	type: 'POST',  
			cache : false,
			beforeSend:showLoading,
          	success: function (result) {  
          		$("#btn_print").css("display","block");
          		$("#user_num").text(result.user_num);
          		$("#thief_num").text(result.thief_num);
          		$("#zone_num").text(result.zone_num);
          		//set_box_body(result.boxMap);
          		console.log(result);
				ydlPie(result.ydljl_line);
				/* ydxwLine(result.ydxwjl_line);
				
				global_ydljl_line = result.ydljl_line;
				global_ydxwjl_line = result.ydxwjl_line;
				
				ydlPie(result.ydltj_pie);
				ydxwPie(result.ydxw_pie);
				ysqdwyPie(result.ysqdwy_pie); */
				
				initydTable(result.ydlList);
				
			},  
			error: function (result) {  
			},
			complete:function()
		 	{
             	hideLoading();
		 	}   
		});  
	}
	
	function undefinedTo0(a){
		if(undefined == a){
			a = 0;
		}
		return a;
	}
	
	function set_box_body(data){
		$("#sjl_yhzs").text(undefinedTo0(data.sjl_yhzs)+"户");
        $("#sjl_sjzs").text(undefinedTo0(data.sjl_sjzs)+"条");
        $("#ydljl_jlzl").text(undefinedTo0(data.ydljl_jlzl)+"类");
		$("#ydxwjl_jlzl").text(undefinedTo0(data.ydxwjl_jlzl)+"类");
		$("#jl_yswyyh").text(undefinedTo0(data.jl_yswyyh)+"户");
		
		for (var i = data.ydljl_jlzl; i > 0; i--)
  		{
  			var txt="<label class='labelClass'>"+ i +"：</label><input name='checkbox1' type='checkbox' value='" + i + "' />";
  			$("#ydl_chexk_box").after(txt);
  		}
  		
  		for (var i = data.ydxwjl_jlzl; i > 0; i--)
  		{
  			var txt="<label class='labelClass'>"+ i +"：</label><input name='checkbox2' type='checkbox' value='" + i + "' />";
  			$("#ydxw_chexk_box").after(txt);
  		}
	}
	
	function ydlPie(data){
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('ydl_line'));
        
        var option = {
        	color :['#c7a9ea', '#ffaa01', '#35acd4',  '#04bf5e', '#fe2546'],
        	backgroundColor: 'rgba(66, 64, 102,1)',
		    title : {
		        text: '',
		        subtext: '',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: ['高可疑用户','中度可疑用户','低可疑用户','非窃电用户']
		    },
		    series : [
		        {
		            name: '访问来源',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:data,
		            itemStyle: {
		             normal:{
                         borderWidth:1,
                         borderColor:'#5a73d0'
                      },		            
		              emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
        };
       
        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
	}
	
	
	
	//不全屏时显示
	function ydxwLine(data){
		// 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('ydl_line_Modal'));
		
		var xArr = [];
		var totalLength = data[0].user_elec.split(",").length;
		for(var i = 0 ; i < totalLength ; i++){
			xArr.push(i);
		}
		
		var legendArr = [];
		var seriesArr = [];
		for(var i = 0 ; i < data.length ; i++){
			var item = data[i];
			if(data.length < 10){
				legendArr.push(item.user_name);
			}
			
			var seriesItem = {"type":"line"};
			seriesItem["name"] = item.user_name;
			seriesItem["data"] = item.user_elec.split(",");
			seriesArr.push(seriesItem);
		}
        // 指定图表的配置项和数据
        var option = {
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
	        data:legendArr
	    },
	    
	    xAxis:  {
	        type: 'category',
	        name:"时间(天)",
	        boundaryGap: false,
	        data: xArr
	    },
	    yAxis: {
	        type: 'value',
	        name:"用电量",
	        axisLabel: {
	            formatter: '{value}'
	        }
	    },
	    series: seriesArr
	};


        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
	}
	
	
	
	function initydTable(data) {
		//初始化表格,动态从服务器加载数据
		$("#ydTable").bootstrapTable('destroy').bootstrapTable({
			height : 435,
			data: data,
			columns: [{
				field:'xzk',
				checkbox:true
				},{
				field:'user_elec',
				visible:false
			}],
			search : true,
			method : "get", //使用get请求到服务器获取数据
			striped : true, //表格显示条纹
			pageSize: 20,
			locale : "zh-CN", //表格汉化
			pagination : true, //启动分页
			queryParams : function queryParams(params) { //设置查询参数
				console.log(params);
				var param = {
					pageNumber : params.pageNumber,
					pageSize : params.pageSize
				};
				return param;
			}
		});

		//setTimeout(setmCustomScrollbar,100);
		function setmCustomScrollbar() {
			$(".fixed-table-container").mCustomScrollbar({
				scrollButtons : {
					enable : true
				}
			});
			$(".fixed-table-container").css("padding", "0px");
		}
	}
	
	function downfile(whichfile)
	{
	    var form1 =  $("#form1")[0];
	    form1.action="<%=path%>/callRAction/downFile.do?whichfile=" + whichfile;
	    form1.submit();
	}
	
	//自定义分析
	function diyfenxi()
	{
	    var checkbox1 = document.getElementsByName("checkbox1");
	    var checkbox2 = document.getElementsByName("checkbox2");


	    checkbox1_val = [];
	    checkbox2_val = [];
	    for(var i = 0; i < checkbox1.length;i++)
	    {
	        if(checkbox1[i].checked)
	        {
	            checkbox1_val.push(checkbox1[i].value);
	        }
	    }
	    
	    for(var i = 0; i < checkbox2.length;i++)
	    {
	        if(checkbox2[i].checked)
	        {
	            checkbox2_val.push(checkbox2[i].value);
	        }
	    }
	    
	    if(checkbox1_val.length == 0)
	    {
	        alert("请选择用电量聚类类别");
	        return;
	    }
	    
	    if(checkbox2_val.length == 0)
	    {
	        alert("请选择用电行为聚类类别");
	        return;
	    }
	    
		$.ajax({
			url: '<%=path%>/callRAction/diyfenxi.do', // 请求的url地址
						dataType : "json", // 返回格式为json
						async : true, // 请求是否异步，默认为异步，这也是ajax重要特性
						data : {
							"ydl_check" : checkbox1_val,
							"ydxw_check" : checkbox2_val
						}, // 参数值
						type : "post", // 请求方式，查询
						contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
						success : function(data) {
							initydTable(data.suspectedList);
							$("#jl_yswyyh").text(
									undefinedTo0(data.jl_yswyyh) + "户");
							ysqdwyPie(data.ysqdwy_pie);

						},
						error : function(result) {
						},
						complete : function() {
						}
					});

		}
		
		//显示隐藏自定义分析工具栏
		function showDiyfenxi() {
			$(".box #customToop").toggle();
		}
		
	</script>
</body>
</html>
