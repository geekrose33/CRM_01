<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="<%=path%>">
    <title>Title</title>
    <script src="ECharts/echarts.min.js"></script>
    <script src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript">
        $(function () {
            $.get(
                "workbench/tran/getChars.do",
                function (data) {
                    getChars(data.total,data.dataList);
                },
                "json"
            );
        });
        function getChars(total,dataList) {
            // 基于准备好的dom，初始化echarts实例
            var myChart1 = echarts.init(document.getElementById('main1'));
            // 指定图表的配置项和数据
            /*
               分析图表所需数据
               total
               dataList
           */
            var option1 = {
                title: {
                    text: '交易阶段漏斗图'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c}%'
                },
                toolbox: {
                    feature: {
                        dataView: { readOnly: false },
                        restore: {},
                        saveAsImage: {}
                    }
                },
                legend: {
                    data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                },
                series: [
                    {
                        name: 'Funnel',
                        type: 'funnel',
                        left: '10%',
                        top: 60,
                        bottom: 60,
                        width: '80%',
                        min: 0,
                        max: total,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            show: true,
                            position: 'inside'
                        },
                        labelLine: {
                            length: 10,
                            lineStyle: {
                                width: 1,
                                type: 'solid'
                            }
                        },
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        },
                        emphasis: {
                            label: {
                                fontSize: 20
                            }
                        },
                        data: dataList
                        /*[
                            { value: 60, name: 'Visit' },
                            { value: 40, name: 'Inquiry' },
                            { value: 20, name: 'Order' },
                            { value: 80, name: 'Click' },
                            { value: 100, name: 'Show' }
                        ]*/
                    }
                ]
            };



            // 饼状图
            var myChart2 = echarts.init(document.getElementById('main2'));
            var option2 = {
                title: {
                    text: '交易阶段占比饼状图',
                    subtext: '交易阶段',
                    left: 'center'
                },
                tooltip: {
                    trigger: 'item'
                },
                legend: {
                    orient: 'vertical',
                    left: 'left'
                },
                series: [
                    {
                        name: 'Access From',
                        type: 'pie',
                        radius: '50%',
                        data: dataList,
                        emphasis: {
                            itemStyle: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    }
                ]
            };
            // 使用刚指定的配置项和数据显示图表。
            myChart1.setOption(option1);
            myChart2.setOption(option2);
        }
    </script>
</head>
<body>
    <!-- 为 ECharts 准备一个定义了宽高的 DOM -->
    <div id="main1" style="width: 600px;height:400px;">


    </div>

    <div id="main2" style="width: 600px;height:400px;">


    </div>
</body>
</html>
