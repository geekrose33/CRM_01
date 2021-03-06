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
			pickerPosition: "bottom-left"
		});

		/*
			http://localhost:8080/CRM_01/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js
		*/

		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });


		// 条件查询
		$("#searchCustomersByConditionBtn").click(function () {
			// 隐藏域存值
			$("#hide-customer-name").val($.trim($("#customer-name").val()));
			$("#hide-customer-owner").val($.trim($("#customer-owner").val()));
			$("#hide-customer-phone").val($.trim($("#customer-phone").val()));
			$("#hide-customer-website").val($.trim($("#customer-website").val()));

			pageList(1,3);
		});

		// 创建客户
		$("#create-customer-btn").click(function () {

			// 打开模态窗口
			$("#createCustomerModal").modal("show");

		});

		$("#saveCusBtn").click(function () {

			$.post(
					"workbench/cus/saveCustomer.do",
					{
						"owner":$.trim($("#create-customerOwner").val()),
						"name":$.trim($("#create-customerName").val()),
						"website":$.trim($("#create-website").val()),
						"phone":$.trim($("#create-phone").val()),
						"description":$.trim($("#create-describe").val()),
						"contactsummary":$.trim($("#create-contactSummary").val()),
						"nextcontacttime":$.trim($("#create-nextContactTime").val()),
						"address":$.trim($("#create-address").val())
					},
					function (data) {
						// success
						if (data.success){
							// 刷新
							pageList(1,3);

							// 创建完成后把输入框的数据刷新
							$("#create-customerName").val("");
							$("#create-website").val("");
							$("#create-phone").val("");
							$("#create-describe").val("");
							$("#create-contactSummary").val("");
							$("#create-nextContactTime").val("");
							$("#create-address").val("");

							// 关闭模态窗口
							$("#createCustomerModal").modal("hide");
						}else{
							alert("添加失败");
						}
					},
					"json"
			)

		});

		// 修改客户
		$("#edit-customer-btn").click(function () {

			// 判断
			var $customer = $("input[name=customer]:checked");
			if ($customer.length == 1){

				var id = $("input[name=customer]:checked").val();
				// 提前铺好数据
				$.get(
						"workbench/cus/getCustomerById.do",
						{
							"id":id
						},
						function (data) {
							// 返回一个customer对象
							$("#edit-customerOwner").val(data.owner);
							$("#edit-customerName").val(data.name);
							$("#edit-phone").val(data.phone);
							$("#edit-website").val(data.website);
							$("#edit-describe").val(data.description);
							$("#edit-contactSummary").val(data.contactsummary);
							$("#edit-nextContactTime").val(data.nextcontacttime);
							$("#edit-address").val(data.address);

							// 打开模态窗口
							$("#editCustomerModal").modal("show");
						},
						"json"
				);

			}else{
				alert("请选择指定客户进行修改");
			}

		});

		$("#editCusBtn").click(function () {

			var id = $("input[name=customer]:checked").val();

			var owner = $("option[name=user]:selected")[0].id;

			$.post(
					"workbench/cus/editCustomer.do",
					{
						"id":id,
						"owner":owner,
						"name":$.trim($("#edit-customerName").val()),
						"phone":$.trim($("#edit-phone").val()),
						"website":$.trim($("#edit-website").val()),
						"description":$.trim($("#edit-describe").val()),
						"contactsummary":$.trim($("#edit-contactSummary").val()),
						"nextcontacttime":$.trim($("#edit-nextContactTime").val()),
						"address":$.trim($("#edit-address").val())
					},
					function (data) {
						// success
						if (data.success){
							// 刷新
							pageList(1,3);

							// 关闭模态窗口
							$("#editCustomerModal").modal("hide");

						}else{
							alert("修改失败");
						}
					},
					"json"
			)


		});

		// 删除客户
		$("#remove-customer-btn").click(function () {

			var $customer = $("input[name=customer]:checked");

			if ($customer.length == 1){

			    if (confirm("确定要删除该客户信息吗")){
			        var id = $customer.val();
			        $.post(
			            "workbench/cus/removeCustomer.do",
                        {
                            "id":id
                        },
                        function (data) {
                            if (data.success){
                                // 刷新页面
                                pageList(1,3);
                            }else {
                                alert("删除失败");
                            }
                        },
						"json"
                    )


                }


            }else{
			    alert("请选择指定客户信息进行删除");
            }



		});


		// 正选反选
		$("#check-all").click(function () {
			$("input[name=customer]").prop("checked",this.checked);
		});

		// 满选
		$("#customer-list").on("click",$("input[name=customer]"),function () {
			$("#check-all").prop("checked",$("input[name=customer]").length === $("input[name=customer]:checked").length);
		});

		// 每次加载都刷新一次
		pageList(1,3);


	});

	function pageList(pageNo,pageSize) {

		$.get(
				"workbench/cus/getCustomers.do",
				{
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#hide-customer-name").val()),
					"owner":$.trim($("#hide-customer-owner").val()),
					"phone":$.trim($("#hide-customer-phone").val()),
					"website":$.trim($("#hide-customer-website").val())
				},
				function (data) {
					// 返回data 是客户集合
					var html = "";

					$.each(data.customers,function (index,value) {

						html += '<tr>';
						html += '<td><input type="checkbox" name="customer" value="'+value.id+'"/></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/cus/useCusInfo.do?id='+value.id+'\';">'+value.name+'</a></td>';
						// 与user表联查
						html += '<td>'+value.owner+'</td>';
						html += '<td>'+value.phone+'</td>';
						html += '<td>'+value.website+'</td>';
						html += '</tr>';

					});

					$("#customer-list").html(html);


					// 数据处理完毕后 对前端展现分页相关信息
					// 计算总页数
					var totalPages = data.totalCount % pageSize === 0 ? data.totalCount / pageSize : parseInt(data.totalCount / pageSize) + 1;
					$("#customer-pagination").bs_pagination({
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

				},
				"json"
		)


	}
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								  <option></option>
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}" ${u.name eq user.name ? "selected" : ""}>${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
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
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCusBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
								  <c:forEach items="${userList}" var="u">
									  <option id="${u.id}" name="user">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
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
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editCusBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="customer-name">
						<input type="hidden" id="hide-customer-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="customer-owner">
						<input type="hidden" id="hide-customer-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="customer-phone">
						<input type="hidden" id="hide-customer-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="customer-website">
						<input type="hidden" id="hide-customer-website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchCustomersByConditionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="create-customer-btn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="edit-customer-btn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="remove-customer-btn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="check-all"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customer-list">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="customer-pagination"></div>


			</div>
			
		</div>
		
	</div>
</body>
</html>