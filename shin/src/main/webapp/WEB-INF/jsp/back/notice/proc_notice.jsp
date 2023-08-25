<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>

<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:url var="imgUrl"        value='/images' />
<c:url var="searchAction"  value='/mon/proc_notice.do' />
<c:url var="timeAction"    value='/ini/ini_time.do' />

<c:set var="isAdmin" value="${sessionScope.session.ISADMIN}"/>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href='<c:url value="/css/nice.css"/>' rel="stylesheet" type="text/css" />
<title>한국전자금융-대외계 운영 관리 시스템</title>
<style type="text/css">
.time {
	width:25px;
	text-align:center;
}

</style>
<script type="text/JavaScript" src='<c:url value="/jquery/jquery-1.11.1.min.js"/>'></script>
<script type="text/JavaScript" src='<c:url value="/js/Common.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/Calendar.js"/>'></script>
<script type="text/JavaScript">
$(document).ready(function() {
	//좌측메뉴
	left_menu(0, 'on');
	
	$("#btnsearch1").bind("click", function(){
		movePage(1);
	});
	
	//시간 범위 현재까지 끄기
	$("#time11, #time22").bind("blur", function() {
		setIsRecently();
	});
	
	//조회조건 초기화
	$("#btnreset1").bind("click", function() {
		resetSearchConditon();
	});
	
	$("#searchForm input[type='text']").bind("keydown", function(){
		var keyCode = window.event.keyCode; 
		if(keyCode==13) movePage(1);
	});
	
});

//시간 조회 범위 현재 까지 설정
function setIsRecently() {
	var parTime01 = '${paramData.time01}';
	var parTime02 = '${paramData.time02}';
	var time11    = strRapd($("#time11").val().replace(/:/g, ""), 6, "0");
	var time22    = strRapd($("#time22").val().replace(/:/g, ""), 6, "0");
	
	if(time11 != parTime01 || time22 != parTime02) {
		$("#isRecently").val("N");
	}
}

//조회조건 초기화
function resetSearchConditon() {
	var $form = $("#searchForm");
	$("input[type='text']", $form).each(function(){
		$(this).val("");
	});
	
	$("#safProcStcd > option[value='A']", $form).prop("selected", "selected");
	timeInsert(0);
}

//검색조건 시간 설정
function timeInsert(min) {
	$("#parMin").val(min);
	$("#isRecently").val("Y");

	$.ajax({
		type : "POST",  
		url  : '${timeAction}',
		data : $("#searchForm").serialize()
	}).done(function(jsonString) {
		var result = $.parseJSON(jsonString);
		
		$("#day01").val(result.day01);
		$("#day02").val(result.day02);
		$("#time01").val(result.time01);
		$("#time11").val(result.time11);
		$("#time02").val(result.time02);
		$("#time22").val(result.time22);
	});
}

//페이지 이동
function movePage(page) {
	$("#page_loading").show();
	$("#page").val(page);
	search();
}

//조회
function search() {
	var day01  = $("#day01").val().replace(/-/g, "");
	var day02  = $("#day02").val().replace(/-/g, "");
	var time11 = strRapd($("#time11").val().replace(/:/g, ""), 6, "0");
	var time22 = strRapd($("#time22").val().replace(/:/g, ""), 6, "0");
	
	if(!isTimeFormat(time11)) {
		alert("시작시간이 옳바르지 않습니다.")
		$("#time11").val("");
	} else if(!isTimeFormat(time22)) {
		alert("종료시간이 옳바르지 않습니다.")
		$("#time22").val("");
	} else {
		var fr = Number("" +day01 +time11);
		var to = Number("" +day02 +time22);
	
		if(to - fr < 0) {
			alert("조회기간 범위가 잘 못 입력되었습니다.");
		} else {
			$("#time01").val(time11);
			$("#time02").val(time22);
			$("#time11").val(convertToTime(time11));
			$("#time22").val(convertToTime(time22));
			
			$("#searchForm").submit();
		}
	}
}

//Calendar Call-Back 함수
var calendarCallBack = [
	//선택시 이벤트
	function(textObj) {
// 		$("#time01").val("000000");
// 		$("#time11").val("00:00:00");
// 		$("#time02").val("235959");
// 		$("#time22").val("23:59:59");
// 		$("#isRecently").val("N");
	},
	//삭제시 이벤트
	function(textObj) {
// 		$("#isRecently").val("N");
	}
];
</script>
</head>
<body>
	<jsp:include page="/include/top.jsp" flush="false" />

	<!-- s: wrap -->
	<div id="wrap">
		<!-- s: container -->
		<div id="container">
			<div id="subpage">
				<!-- s: Left -->
				<div class="leftmenu">
					<jsp:include page="/include/left.jsp" flush="false" />
				</div>
				<!-- e: Left -->

				<!-- s: contents -->
				<div id="contents">
					<div class="contents">
						<!-- s: title -->
						<table width="880px;" border="0" cellspacing="0" cellpadding="0"
							class="title">
							<tr>
								<td class="bullet">
									<div>
										<div class="font_title" style="font-size:23px">프로세스 장애 통보 내역</div>
									</div>
								</td>
								<td class="route">
									<div>
										<a href="#"> Home </a>&gt;<a href="#"> 모니터링 </a><a href="#"></a>&gt;<a href="#"> 프로세스 현황</a>
									</div>
								</td>
							</tr>
						</table>

						<!-- s: searchbox -->
						<div class="search">
							<form:form id="searchForm" action="${searchAction}" method="post" modelAttribute="paramData">
								<form:hidden path="page"/>
							
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="tit">조회기간</td>
										<td class="con">
											<form:hidden path="parMin"/>
											<form:hidden path="isRecently"/>
											<form:input path="day01" readonly="true" cssClass="input_date" onfocus="openCalendar2(document.all('day01'), calendarCallBack)"/>
											<img src="${imgUrl}/btn_calendar.gif" id="cal01" onclick="openCalendar2(document.all('day01'), calendarCallBack)" onMouseOver="MM_swapImage('cal01','','${imgUrl}/btn_calendar_on.gif',0)" onMouseOut="MM_swapImgRestore()" />
											<form:input path="time11" cssClass="input c" cssStyle="width:55px;" title="HHMISS" maxlength="8"/>
											<form:hidden path="time01"/>
											~
											<form:input path="day02" readonly="true" cssClass="input_date" onfocus="openCalendar2(document.all('day02'), calendarCallBack)"/>
											<img src="${imgUrl}/btn_calendar.gif" id="cal02" onclick="openCalendar2(document.all('day02'), calendarCallBack)" onMouseOver="MM_swapImage('cal02','','${imgUrl}/btn_calendar_on.gif',0)" onMouseOut="MM_swapImgRestore()" />
											<form:input path="time22" cssClass="input c" cssStyle="width:55px;" title="HHMISS" maxlength="8"/>
											<form:hidden path="time02"/>
											&nbsp;
											<img src="${imgUrl}/btn_in_5minute.gif"   alt="5분"       border="0" onclick="timeInsert(5)" >
											<img src="${imgUrl}/btn_in_10minute.gif"  alt="10분"      border="0" onclick="timeInsert(10)">
											<img src="${imgUrl}/btn_in_60minute.gif"  alt="60분"      border="0" onclick="timeInsert(60)">
											<img src="${imgUrl}/btn_in_timereset.gif" alt="시간초기화" border="0" onclick="timeInsert(0)" >
										</td>
										<td class="btn">
											<img src="${imgUrl}/btn_search.gif" id="btnsearch1" onMouseOver="MM_swapImage('btnsearch1','','${imgUrl}/btn_search_on.gif',0)" onMouseOut="MM_swapImgRestore()">
											<img src="${imgUrl}/btn_reset.gif"  id="btnreset1"  onMouseOver="MM_swapImage('btnreset1' ,'','${imgUrl}/btn_reset_on.gif' ,0)" onMouseOut="MM_swapImgRestore()">
										</td>
									</tr>
								</table>
							</form:form>
						</div>
						<div class="clear" id="end_search"></div>
						
						<!-- s: List -->
						<table id="resList" width="880" border="0" cellspacing="0" cellpadding="0" class="list01">
							<thead>
								<tr>
									<th>번호</th>
									<th>발생위치</th>
									<th>내용</th>
									<th>호스트 이름</th>
									<th class="end">발생시각</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${noticeList}" var="noticeData" varStatus="status">
									<tr>
										<td>${paramData.startRowNum + status.index}</td>
										<td>${noticeData.alarmSource}</td>
										<td>${noticeData.alarmCtt}</td>
										<td>${noticeData.procEnname}</td>
										<td class="end">${fn:substring(noticeData.alarmTmst, 0, 10)}<div class="blue">${fn:substring(noticeData.alarmTmst, 11, 19)}</div></td>
									</tr> 
								</c:forEach>
							</tbody>
						</table>
						<!-- Paging -->
						<jsp:include page="/WEB-INF/jsp/include/paging.jsp" flush="false"/>
					</div>
				</div>
				<div class="clear"></div>
				<!-- e: contents -->

				<!-- s: bottom -->
				<div id="bottom"><jsp:include page="/include/bottom.jsp" flush="false" /></div>
			</div>
		</div>
	</div>
	
	
</body>
</html>
