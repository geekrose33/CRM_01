<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<%--引入分页插件--%>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	$(function(){
		// 时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});



		// 为创建按钮绑定事件
		$("#addBtn").click(function () {

			// 过后台取出users数据
			$.ajax({
				url:"workbench/clue/getUsers.do",
				dataType:"json",
				type:"get",
				success:function (data) {

					var html = "<option></option>\n";

					$.each(data,function (index,value) {
						html += "<option value='"+value.id+"'>"+ value.name +"</option>\n";
					});

					var uid = '${user.id}';

					$("#create-clueOwner").html(html);

					// 将所有者默认为当前用户的姓名
					$("#create-clueOwner").val(uid);


					// 打开模态窗口
					$("#createClueModal").modal("show");

				}
			});


		});

		// 为添加按钮绑定事件
		$("#saveBtn").click(function () {

			$.ajax({
				url:"workbench/clue/saveClue.do",
				data:{
					"owner":$.trim($("#create-clueOwner").val()),
					"company":$.trim($("#create-company").val()),
					"appellation":$.trim($("#create-call").val()),
					"fullname":$.trim($("#create-surname").val()),
					"job":$.trim($("#create-job").val()),
					"email":$.trim($("#create-email").val()),
					"phone":$.trim($("#create-phone").val()),
					"website":$.trim($("#create-website").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"state":$.trim($("#create-status").val()),
					"source":$.trim($("#create-source").val()),
					"description":$.trim($("#create-describe").val()),
					"contactsummary":$.trim($("#create-contactSummary").val()),
					"nextcontacttime":$.trim($("#create-nextContactTime").val()),
					"address":$.trim($("#create-address").val())
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					// 返回一个success标识
					if (data){

						// 刷新列表
						pageList(1,5);
						// 关闭模态窗口
						$("#createClueModal").modal("hide");
					}else {
						alert("添加线索失败");
					}
				}
			})

		});


		// 条件查询
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($("#search-clue-name").val()));
			$("#hidden-company").val($.trim($("#search-clue-company").val()));
			$("#hidden-phone").val($.trim($("#search-clue-phone").val()));
			$("#hidden-mphone").val($.trim($("#search-clue-mphone").val()));
			$("#hidden-owner").val($.trim($("#search-clue-owner").val()));
			$("#hidden-clue").val($.trim($("#search-option-clues").val()));
			$("#hidden-state").val($.trim($("#search-option-states").val()));
			pageList(1,5);
		});



		// 修改按钮
        $("#editBtn").click(function () {
            // 打开模态窗口前 先加载数据
			// 指定修改模态窗口 将id传进去
			var $id = $("input[name=one]:checked");
			if ($id.length == 1){
				var id = $id.val();
				// $("#editClueModal").modal("show");
			}else{
				alert("请选择指定的线索");
			}

			$.ajax({
				url:"workbench/clue/editClue.do",
				dataType:"json",
				type:"get",
				data:{"id":id},
				success:function (data) {
					// data: 返回Clue
					if (data!=null){
						/*
							返回
								指定clue对象
								users表中的name
									线索状态和线索来源从application中获取
						*/
						var html = "<option></option>\n";

						$.each(data.users,function (index,value) {
							html += "<option>"+value.name+"</option>\n";
						});

						$("#edit-clueOwner").html(html);
						$("#edit-clueOwner").val(data.clue.owner);
						// 称呼 状态 来源
						$("#edit-call").val(data.clue.appellation);
						$("#edit-status").val(data.clue.state);
						$("#edit-source").val(data.clue.source);
						// 设置公司
						$("#edit-company").val(data.clue.company);
						// 设置姓名
						$("#edit-surname").val(data.clue.fullname);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-mphone").val(data.clue.mphone);
						$("#edit-website").val(data.clue.website);
						$("#edit-job").val(data.clue.job);
						$("#edit-email").val(data.clue.email);
						$("#edit-describe").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactsummary);
						$("#edit-nextContactTime").val(data.clue.nextcontacttime);
						$("#edit-address").val(data.clue.address);

						// 打开模态窗口
						$("#editClueModal").modal("show");

					}else{
						// 获取失败
						alert("修改失败");
					}
				}
			})

        });

        // 更新按钮
		$("#updateBtn").click(function () {
			var id = $("input[name=one]:checked").val();
			// 修改
			$.post(
					"workbench/clue/updateClue.do",
					{
						"id":id,
						"owner":$.trim($("#edit-clueOwner").val()),
						"appellation":$.trim($("#edit-call").val()),
						"state":$.trim($("#edit-status").val()),
						"source":$.trim($("#edit-source").val()),
						"company":$.trim($("#edit-company").val()),
						"fullname":$.trim($("#edit-surname").val()),
						"phone":$.trim($("#edit-phone").val()),
						"mphone":$.trim($("#edit-mphone").val()),
						"website":$.trim($("#edit-website").val()),
						"job":$.trim($("#edit-job").val()),
						"email":$.trim($("#edit-email").val()),
						"description":$.trim($("#edit-describe").val()),
						"contactsummary":$.trim($("#edit-contactSummary").val()),
						"nextcontacttime":$.trim($("#edit-nextContactTime").val()),
						"address":$.trim($("#edit-address").val())
					},
					function (data) {
						// 返回修改标识 success
						if (data.success){
							// 刷新列表
							pageList(1,5);
							// 关闭模态窗口
							$("#editClueModal").modal("hide");
						}else{
							alert("修改失败");
						}
					},
					"json"
			)
		});
        // 删除按钮
		$("#deleteBtn").click(function () {
			// 找到指定clue
			var id = $("input[name=one]:checked").val();
			if (confirm("确定要删除么")){
				$.post(
						"workbench/clue/deleteClue.do",
						{
							"id":id
						},
						function (data) {
							if (data.success){
								// 刷新列表
								pageList(1,5);
							}else{
								alert("删除失败");
							}
						},
						"json"
				)
			}
		});


		// 全选反选
		$("#all").click(function () {
			$("input[name=one]").prop("checked",this.checked);
		});

		// 点满选择按钮 全选也进入被点击状态
		$("#pageListBody").on("click",$("input[name=one]"),function () {
			$("#all").prop("checked",$("input[name=one]").length===$("input[name=one]:checked").length);
		});

		// 每次刷新点击都要刷新一下列表
		pageList(1,5);




	});

	function pageList(pageNo,pageSize) {
		// 每次刷新 将被点击的选择框也刷新
		$("#all").prop("checked",false);
		// 刷新列表信息
		$("#search-clue-name").val($.trim($("#hidden-name").val()));
		$("#search-clue-company").val($.trim($("#hidden-company").val()));
		$("#search-clue-mphone").val($.trim($("#hidden-mphone").val()));
		$("#search-clue-owner").val($.trim($("#hidden-owner").val()));
		$("#search-clue-phone").val($.trim($("#hidden-phone").val()));
		$("#search-option-clues").val($.trim($("#hidden-clue").val()));
		$("#search-option-states").val($.trim($("#hidden-state").val()));

		$.ajax({
			url:"workbench/clue/pageList.do",
			dataType:"json",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname":$.trim($("#search-clue-name").val()),
				"company":$.trim($("#search-clue-company").val()),
				"phone":$.trim($("#search-clue-phone").val()),
				"mphone":$.trim($("#search-clue-mphone").val()),
				"owner":$.trim($("#search-clue-owner").val()),
				"source":$.trim($("#search-option-clues").val()),
				"state":$.trim($("#search-option-states").val())
			},
			success:function (data) {
				// 返回clue列表
				var html = "";
				$.each(data.clues,function (index,value) {

					html += "<tr>";
					html += '<td><input type="checkbox" name="one" value="'+value.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detailClue.do?id='+value.id+'\';">'+value.fullname+value.appellation+'</a></td>';
					html += "<td>"+value.company+"</td>";
					html += "<td>"+value.phone+"</td>";
					html += "<td>"+value.mphone+"</td>";
					html += "<td>"+value.source+"</td>";
					html += "<td>"+value.owner+"</td>";
					html += "<td>"+value.state+"</td>";
					html += "</tr>";

				});
				$("#pageListBody").html(html);


				// 数据处理完毕后 对前端展现分页相关信息
				// 计算总页数
				var totalPages = data.totalCount % pageSize === 0 ? data.totalCount / pageSize : parseInt(data.totalCount / pageSize) + 1;
				$("#cluePage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.totalCount, // 总记录条数

					visiblePageLinks: 5, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		});



	}

</script>
</head>
<body>
<%--	隐藏域存储条件查询的条件信息--%>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-company"/>
	<input type="hidden" id="hidden-phone"/>
	<input type="hidden" id="hidden-mphone"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-clue"/>
	<input type="hidden" id="hidden-state"/>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
									<c:forEach items="${clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <c:forEach items="${appellationList}" var="a">
									  <option>${a.text}</option>
								  </c:forEach>
<%--								  <option selected>先生</option>--%>
<%--								  <option>夫人</option>--%>
<%--								  <option>女士</option>--%>
<%--								  <option>博士</option>--%>
<%--								  <option>教授</option>--%>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${clueStateList}" var="c">
										<option>${c.text}</option>
									</c:forEach>
<%--								  <option>试图联系</option>--%>
<%--								  <option>将来联系</option>--%>
<%--								  <option selected>已联系</option>--%>
<%--								  <option>虚假线索</option>--%>
<%--								  <option>丢失线索</option>--%>
<%--								  <option>未联系</option>--%>
<%--								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="s">
										<option>${s.text}</option>
									</c:forEach>
<%--								  <option selected>广告</option>--%>
<%--								  <option>推销电话</option>--%>
<%--								  <option>员工介绍</option>--%>
<%--								  <option>外部介绍</option>--%>
<%--								  <option>在线商场</option>--%>
<%--								  <option>合作伙伴</option>--%>
<%--								  <option>公开媒介</option>--%>
<%--								  <option>销售邮件</option>--%>
<%--								  <option>合作伙伴研讨会</option>--%>
<%--								  <option>内部研讨会</option>--%>
<%--								  <option>交易会</option>--%>
<%--								  <option>web下载</option>--%>
<%--								  <option>web调研</option>--%>
<%--								  <option>聊天</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
<%--	条件查询的搜索框--%>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-clue-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text"  id="search-clue-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-clue-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-option-clues">
					  	  <option></option>
					  	  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-clue-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-clue-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-option-states">
					  	<option></option>
					  	<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="all" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="pageListBody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>


                        <%--<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>