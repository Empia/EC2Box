<%
/**
 * Copyright 2013 Sean Kavanagh - sean.p.kavanagh6@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>

    <jsp:include page="../_res/inc/header.jsp"/>

    <script type="text/javascript">
        $(document).ready(function() {

            $("#add_dialog").dialog({
                autoOpen: false,
                height: 350,
                width: 400,
                modal: true
            });

            $(".edit_dialog").dialog({
                autoOpen: false,
                height: 350,
                width: 400,
                modal: true
            });

            //open add dialog
            $("#add_btn").button().click(function() {
                $("#add_dialog").dialog("open");
            });
            //open edit dialog
            $(".edit_btn").button().click(function() {
                //get dialog id to open
                var id = $(this).attr('id').replace("edit_btn_", "");
                $("#edit_dialog_" + id).dialog("open");

            });
            //call delete action
            $(".del_btn").button().click(function() {
                var id = $(this).attr('id').replace("del_btn_", "");
                window.location = 'deleteUser.action?user.id='+ id +'&sortedSet.orderByDirection=<s:property value="sortedSet.orderByDirection" />&sortedSet.orderByField=<s:property value="sortedSet.orderByField"/>';
            });
            //submit add or edit form
            $(".submit_btn").button().click(function() {
                $(this).parents('form:first').submit();
            });
            //close all forms
            $(".cancel_btn").button().click(function() {
                $("#add_dialog").dialog("close");
                $(".edit_dialog").dialog("close");
            });

            $(".sort,.sortAsc,.sortDesc").click(function() {
                var id = $(this).attr('id')

                if ($('#viewUsers_sortedSet_orderByDirection').attr('value') == 'asc') {
                    $('#viewUsers_sortedSet_orderByDirection').attr('value', 'desc');

                } else {
                    $('#viewUsers_sortedSet_orderByDirection').attr('value', 'asc');
                }

                $('#viewUsers_sortedSet_orderByField').attr('value', id);
                $("#viewUsers").submit();

            });
            <s:if test="sortedSet.orderByField!= null">
            $('#<s:property value="sortedSet.orderByField"/>').attr('class', '<s:property value="sortedSet.orderByDirection"/>');
            </s:if>


            $('.scrollableTable').tableScroll({height:500});
            $(".scrollableTable tr:odd").css("background-color", "#e0e0e0");
        });
    </script>

    <s:if test="fieldErrors.size > 0 || actionErrors.size > 0">
        <script type="text/javascript">
            $(document).ready(function() {
                <s:if test="user.id>0">
                $("#edit_dialog_<s:property value="user.id"/>").dialog("open");
                </s:if>
                <s:else>
                $("#add_dialog").dialog("open");
                </s:else>


            });
        </script>
    </s:if>

    <title>EC2Box - Manage Instance Administrators</title>

</head>
<body>

    <jsp:include page="../_res/inc/navigation.jsp"/>

    <div class="container">
        <s:form action="viewUsers">
            <s:hidden name="sortedSet.orderByDirection" />
            <s:hidden name="sortedSet.orderByField"/>
        </s:form>

        <h3>Manage Instance Administrators</h3>

        <p>Add / Delete Instance Administrators below</p>

        <s:if test="sortedSet.itemList!= null && !sortedSet.itemList.isEmpty()">
                <table class="table-striped scrollableTable" style="min-width: 80%">
                    <thead>

                    <tr>

                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@SORT_BY_USERNAME"/>" class="sort">Username
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@SORT_BY_LAST_NM"/>" class="sort">Last
                            Name
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@SORT_BY_FIRST_NM"/>" class="sort">First
                            Name
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@SORT_BY_EMAIL"/>" class="sort">Email
                            Address
                        </th>
                        <th>&nbsp;</th>
                    </tr>
                    </thead>
                    <tbody>
                    <s:iterator var="user" value="sortedSet.itemList" status="stat">
                    <tr>
                        <td><s:property value="username"/></td>
                        <td><s:property value="lastNm"/></td>
                        <td><s:property value="firstNm"/></td>
                        <td><s:property value="email"/></td>
                            <td>
                                <div id="edit_btn_<s:property value="id"/>" class="btn btn-primary edit_btn" style="float:left">
                                    Edit
                                </div>
                                <div id="del_btn_<s:property value="id"/>" class="btn btn-primary del_btn" style="float:left">
                                    Delete
                                </div>
                                <div style="clear:both"></div>
                            </td>
                    </tr>
                    </s:iterator>
                    </tbody>
                </table>
        </s:if>





            <div id="add_btn" class="btn btn-primary">Add Administrator</div>
            <div id="add_dialog" title="Add User">
                <s:actionerror/>
                <s:form action="saveUser" class="save_user_form_add" autocomplete="off">
                    <s:textfield name="user.username" label="Username" size="15"/>
                    <s:textfield name="user.firstNm" label="First Name" size="15"/>
                    <s:textfield name="user.lastNm" label="Last Name" size="15"/>
                    <s:textfield name="user.email" label="Email Address" size="25"/>
                    <s:password name="user.password" value="" label="Password" size="15"/>
                    <s:password name="user.passwordConfirm" value="" label="Confirm Password" size="15"/>
                    <s:hidden name="sortedSet.orderByDirection"/>
                    <s:hidden name="sortedSet.orderByField"/>
                    <tr>
                    <td>&nbsp;</td>
                    <td>
                    <div class="btn btn-primary submit_btn">Submit</div>
                    <div class="btn btn-primary cancel_btn">Cancel</div>
                    </td>
                    </tr>
                </s:form>

            </div>


            <s:iterator var="user" value="sortedSet.itemList" status="stat">
                <div id="edit_dialog_<s:property value="id"/>" title="Edit User" class="edit_dialog">
                    <s:actionerror/>
                    <s:form action="saveUser" id="save_user_form_edit_%{id}" autocomplete="off">
                        <s:textfield name="user.username" value="%{username}" label="Username" size="15"/>
                        <s:textfield name="user.firstNm" value="%{firstNm}" label="First Name" size="15"/>
                        <s:textfield name="user.lastNm" value="%{lastNm}" label="Last Name" size="15"/>
                        <s:textfield name="user.email" value="%{email}" label="Email Address" size="25"/>
                        <s:password name="user.password" value="" label="Password" size="15"/>
                        <s:password name="user.passwordConfirm" value="" label="Confirm Password" size="15"/>
                        <s:hidden name="user.id" value="%{id}"/>
                        <s:hidden name="sortedSet.orderByDirection"/>
                        <s:hidden name="sortedSet.orderByField"/>
                        <tr>
                        <td>&nbsp;</td>
                        <td>
                        <div class="btn btn-primary submit_btn">Submit</div>
                        <div class="btn btn-primary cancel_btn">Cancel</div>
                        </td>
                        </tr>
                    </s:form>
                </div>
            </s:iterator>


    </div>
</body>
</html>
