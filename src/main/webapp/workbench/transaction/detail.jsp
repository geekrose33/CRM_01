<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="javafx.stage.Stage" %>
<%@ page import="com.geekrose.crm.settings.domain.DicValue" %>
<%@ page import="com.geekrose.crm.workbench.domain.Transaction" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

Map<String,String> pMap =(Map<String,String>) application.getAttribute("pMap");
Set<String> keys = pMap.keySet();

// 获取stageList
	List<DicValue> stages = (List<DicValue>) application.getAttribute("stageList");

// 获取可能性为0的索引
	int point = 0;
	for (int i = 0; i < stages.size(); i++) {

		// 获取当前阶段的dicValue对象
		DicValue dv = stages.get(i);

		// 获取当前阶段属性值
		String stage = dv.getValue();

		// 获取当前可能性
		String possibility = pMap.get(stage);
		if ("0".equals(possibility)){
			point = i;
			// 节省空间资源
			break;
		}

	}


%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	// 可能性的设置
	var json = {

		<%
                    for (String stage:keys){

                        String value = pMap.get(stage);
        %>
		"<%=stage%>":<%=value%>,
		<%
                    }
        %>

	};


	$(function(){

		var stage = "${tran.stage}";

		var possibility = json[stage];
		$("#detail-possibility").html(possibility);


		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });


		// 刷新 历史
		hisPageList("${tran.id}",json)
	});
	
	function hisPageList(id,json) {

		$.get(
				"workbench/tran/getHisListByTranId.do",
				{
					"tranId":id
				},
				function (data) {
					// 返回histroy list
					var html = "";
					$.each(data,function (index,value) {

						// 获取可能性


						html += '<tr>';
						html += '<td>'+value.stage+'</td>';
						html += '<td>'+value.money+'</td>';
						html += '<td>'+json[value.stage]+'</td>';
						html += '<td>'+value.expecteddate+'</td>';
						html += '<td>'+value.createtime+'</td>';
						html += '<td>'+value.createby+'</td>';
						html += '</tr>';
					});

					$("#his-list").html(html);
				},
				"json"
		)

	}

	// 改变 交易阶段 方法
	// 参数： 遍历的阶段 和 图标id
	function changeStage(stage,index) {
		// alert(stage);
		// alert(index);

		// ajax后台修改 交易表（修改） 交易历史表（添加）
		// 返回修改 成功标识  修改人 修改时间 阶段 可能性

		$.post(
				"workbench/tran/changeStage.do",
				{
					"id" : "${tran.id}",
					"stage" : stage,
					"money" : "${tran.money}", // 用于交易历史表
					"expecteddate" : "${tran.expecteddate}" // 用于交易历史表
				},
				function (data) {
					// 需要 返回修改人 修改时间 阶段 可能性 封装成对象返回
					if (data.success){
						// 修改详情页
						$("#detail-edittime").html(data.tran.edittime);
						$("#detail-editby").html(data.tran.editby);
						$("#detail-stage").html(data.tran.stage);

						// 可能性的设置
						// 可能性的设置

						var stage = data.tran.stage;
						var possibility = json[stage];
						// 设置
						$("#detail-possibility").html(possibility);

						// 修改图标
						changeIcon(stage,index);

						// 刷新历史
						hisPageList("${tran.id}",json);

					}else {
						alert("修改阶段失败");
					}
				},
				"json"
		)


	}
	function changeIcon(stage,index) {
		// 阶段
		var currentStage = stage;

		// 可能性
		var currentPossibility = json[currentStage];

		// index 当前阶段的索引
		// 可能性为0 前七个为 黑圈  后两个 黑叉 红叉
		if (currentPossibility == 0){
			for (var i = 0; i < <%=stages.size()%>; i++) {
				if (i < "<%=point%>"){
					// 黑圈
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-record mystage");
					$("#"+i).css("color","#000000");
				}else{
					if (index == i){
						// 当前阶段 红叉
						// 由于是修改标签的样式 所以需要先删除原有样式
						$("#"+i).removeClass();
						// 添加样式
						$("#"+i).addClass("glyphicon glyphicon-remove mystage");
						$("#"+i).css("color","#FF0000");
					}else{
						// 黑叉
						$("#"+i).removeClass();
						// 添加样式
						$("#"+i).addClass("glyphicon glyphicon-remove mystage");
						$("#"+i).css("color","#000000");
					}
				}
			}
		}else{
		// 可能性不为0 前七个 黑圈 绿圈 绿灯 后两个 黑叉
			for (var i = 0; i < <%=stages.size()%>; i++) {
				if (i >= "<%=point%>"){
					// 黑叉
					$("#"+i).removeClass();
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					$("#"+i).css("color","#000000");
				}else{
					if (index == i){
						// 绿灯
						$("#"+i).removeClass();
						$("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
						$("#"+i).css("color","#90F790");
					}else if (i < index){
						// 绿圈
						$("#"+i).removeClass();
						$("#"+i).addClass("glyphicon glyphicon-record mystage");
						$("#"+i).css("color","#90F790");
					}else{
						// 黑圈
						$("#"+i).removeClass();
						$("#"+i).addClass("glyphicon glyphicon-record mystage");
						$("#"+i).css("color","#000000");
					}
				}
			}

		}


	}

</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<%--
		这里写java脚本 逻辑判断
		两种情况：
			一 当前交易的阶段可能性不为0
				前七个 可能 绿圈 绿灯 黑圈
				后两个 黑叉
			二 当前交易的阶段可能性为0
				前七个 黑圈
				后两个 可能 红叉 可能黑叉
--%>
<%

			// 先获取当前交易
			Transaction tran = (Transaction) request.getAttribute("tran");
			// 获取当前交易的阶段
			String currentstage = tran.getStage();
			// 获取当前交易的可能性
			String currentpossibility = pMap.get(currentstage);
			// 进行判断可能性是否为0
			if ("0".equals(currentpossibility)){
				// 可能性为0
				for (int i = 0; i < stages.size(); i++) {

					// 获取遍历的阶段和可能性
					DicValue dicValue = stages.get(i);
					String stage = dicValue.getValue();
					String possibility = pMap.get(stage);

					if ("0".equals(possibility)){
						// 黑叉 或者 红叉
						if (currentstage.equals(stage)){
							// 红叉
%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #FF0000;"></span>
		-----------
<%
						}else{
							// 黑叉
%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
	<%
						}

					}else{
						// 黑圈
	%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-record mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
<%

					}
				}
			}else{
				// 可能性不为0
				// 先遍历出本交易阶段的索引值
				int index = 0;
				for (int i = 0; i < stages.size(); i++) {
					DicValue dicValue = stages.get(i);
					String stage = dicValue.getValue();
					String possibility = pMap.get(stage);

					if (currentstage.equals(stage)){
						index = i;
						break;
					}

				}

				// 获取完索引值 遍历判断
				for (int i = 0; i < stages.size(); i++) {
					// 将每一个 阶段 可能性遍历出来
					DicValue dicValue = stages.get(i);
					String stage = dicValue.getValue();
					String possibility = pMap.get(stage);

					if ("0".equals(possibility)){
						// 黑叉
%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-remove mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------

	<%
					}else{
						// 判断 是否为当前
						if (i == index){
							// 绿灯
	%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #90F790;"></span>
		-----------
	<%

						}else if (i < index){
							// 绿圈
	%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #90F790;"></span>
		-----------
<%

						}else{
							// 黑圈
%>
		<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')" class="glyphicon glyphicon-record mystage" data-toggle="popover"
			  data-placement="bottom" data-content="<%=stage%>" style="color: #000000;"></span>
		-----------
		<%


						}
					}
				}
			}

		%>

		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${tran.expecteddate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expecteddate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerid}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detail-stage">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="detail-possibility"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityid}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsid}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createby}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createtime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="detail-editby">${tran.editby}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="detail-edittime">${tran.edittime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${tran.contactsummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextcontacttime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="his-list">
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>