<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org" xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout" layout:decorate="layout/basic">
    <th:block layout:fragment="title">
        <title>글작성 페이지</title>
    </th:block>

    <th:block layout:fragment="content">
        <div class="page_tits">
            <h3>게시판 관리</h3>
            <p class="path"><strong>현재 위치 :</strong> <span>게시판 관리</span> <span>리스트형</span> <span>글작성</span></p>
        </div>

        <div class="content">
            <section>
                <form id="saveForm" method="post" autocomplete="off">
                    <!--/* 게시글 수정인 경우, 서버로 전달할 게시글 번호 (PK) */-->
                    <input type="hidden" id="id" name="id" th:if="${post != null}" th:value="${post.id}" />

                    <!--/* 서버로 전달할 공지글 여부 */-->
                    <input type="hidden" id="noticeYn" name="noticeYn" />
                    <table class="tb tb_row">
                        <colgroup>
                            <col style="width:15%;" /><col style="width:35%;" /><col style="width:15%;" /><col style="width:35%;" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">공지글</th>
                                <td><span class="chkbox"><input type="checkbox" id="isNotice" name="isNotice" class="chk" /><i></i><label for="isNotice"> 설정</label></span></td>

                                <th scope="row">등록일</th>
                                <td colspan="3"><input type="text" id="createdDate" name="createdDate" readonly /></td>
                            </tr>

                            <tr>
                                <th>제목 <span class="es">필수 입력</span></th>
                                <td colspan="3"><input type="text" id="title" name="title" maxlength="50" placeholder="제목을 입력해 주세요." /></td>
                            </tr>

                            <tr>
                                <th>이름 <span class="es">필수 입력</span></th>
                                <td colspan="3"><input type="text" id="writer" name="writer" maxlength="10" placeholder="이름을 입력해 주세요." /></td>
                            </tr>

                            <tr>
                                <th>내용 <span class="es">필수 입력</span></th>
                                <td colspan="3"><textarea id="content" name="content" cols="50" rows="10" placeholder="내용을 입력해 주세요."></textarea></td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <p class="btn_set">
                    <button type="button" id="saveBtn" onclick="savePost();" class="btns btn_st3 btn_mid">저장</button>
                    <a th:href="@{/post/list.do}" class="btns btn_bdr3 btn_mid">뒤로</a>
                </p>
            </section>
        </div> <!--/* .content */-->
    </th:block>

    <th:block layout:fragment="script">
        <script th:inline="javascript">
        /*<![CDATA[*/

	     window.onload = () => {
	        renderPostInfo();
	    }
	
	
	    // 게시글 상세정보 렌더링
	    function renderPostInfo() {
	        const post = [[ ${post} ]];
	
	        if ( !post ) {
	            initCreatedDate();
	            return false;
	        }
	
	        const form = document.getElementById('saveForm');
	        const fields = ['id', 'title', 'content', 'writer', 'noticeYn'];
	        form.isNotice.checked = post.noticeYn;
	        form.createdDate.value = dayjs(post.createdDate).format('YYYY-MM-DD HH:mm');
	
	        fields.forEach(field => {
	            form[field].value = post[field];
	        })
	    }
	
	
	    // 등록일 초기화
	    function initCreatedDate() {
	        document.getElementById('createdDate').value = dayjs().format('YYYY-MM-DD');
	    }
	
	
	    // 게시글 저장(수정)
	    function savePost() {
	        const form = document.getElementById('saveForm');
	        const fields = [form.title, form.writer, form.content];
	        const fieldNames = ['제목', '이름', '내용'];
	
	        for (let i = 0, len = fields.length; i < len; i++) {
	            isValid(fields[i], fieldNames[i]);
	        }
	
	        document.getElementById('saveBtn').disabled = true;
	        form.noticeYn.value = form.isNotice.checked;
	        form.action = [[ ${post == null} ]] ? '/post/save.do' : '/post/update.do';
	        form.submit();
	    }

        /*]]>*/
        </script>
    </th:block>
</html>