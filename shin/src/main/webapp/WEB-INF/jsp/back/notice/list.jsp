<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org" xmlns:layout="http://www.ultraq.net.nz/thymeleaf/layout" layout:decorate="layout/basic">
    <th:block layout:fragment="title">
        <title>리스트 페이지</title>
    </th:block>

    <th:block layout:fragment="content">
        <div class="page_tits">
            <h3>게시판 관리</h3>
            <p class="path"><strong>현재 위치 :</strong> <span>게시판 관리</span> <span>리스트형</span> <span>리스트</span></p>
        </div>

        <div class="content">
            <section>
                <!--/* 검색 */-->
                <div class="search_box">
                    <form id="searchForm" onsubmit="return false;" autocomplete="off">
                        <div class="sch_group fl">
                            <select title="검색 유형 선택">
                                <option value="">전체 검색</option>
                                <option value="">제목</option>
                                <option value="">내용</option>
                            </select>
                            <input type="text" placeholder="키워드를 입력해 주세요." title="키워드 입력"/>
                            <button type="button" class="bt_search"><i class="fas fa-search"></i><span class="skip_info">검색</span></button>
                        </div>
                    </form>
                </div>
              
                <!--/* 리스트 */-->
                <table class="tb tb_col">
                    <colgroup>
                        <col style="width:50px;"/><col style="width:7.5%;"/><col style="width:auto;"/><col style="width:10%;"/><col style="width:15%;"/><col style="width:7.5%;"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox"/></th>
                            <th scope="col">번호</th>
                            <th scope="col">제목</th>
                            <th scope="col">작성자</th>
                            <th scope="col">등록일</th>
                            <th scope="col">조회</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr th:if="${not #lists.isEmpty( posts )}" th:each="row, status : ${posts}">
                            <td><input type="checkbox"/></td>
                            <td th:text="${row.noticeYn == false ? (status.size - status.index) : '공지'}"></td>
                            <td class="tl"><a th:href="@{/post/view.do( id=${row.id} )}" th:text="${row.title}"></a></td>
                            <td th:text="${row.writer}"></td>
                            <td th:text="${#temporals.format( row.createdDate, 'yyyy-MM-dd HH:mm' )}"></td>
                            <td th:text="${row.viewCnt}"></td>
                        </tr>
    
                        <tr th:unless="${not #lists.isEmpty( posts )}">
                            <td colspan="5">
                                <div class="no_data_msg">검색된 결과가 없습니다.</div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!--/* 페이지네이션 */-->
                <div class="paging">
                    <a href="#" class="page_bt first">첫 페이지</a><a href="#" class="page_bt prev">이전 페이지 그룹</a>
                    <p><span class="on">1</span><a href="#">2</a><a href="#">3</a><a href="#">4</a><a href="#">5</a><a href="#">6</a><a href="#">7</a><a href="#">8</a><a href="#">9</a><a href="#">10</a></p>
                    <a href="#" class="page_bt next">다음 페이지 그룹</a><a href="#" class="page_bt last">마지막 페이지</a>
                </div>

                <!--/* 버튼 */-->
                <p class="btn_set tr">
                    <a th:href="@{/post/write.do}" class="btns btn_st3 btn_mid">글쓰기</a>
                </p>
            </section>
        </div> <!--/* .content */-->
    </th:block>
</html>