<?php
/* Copyright 2012 Alessandro Staniscia (email : alessandro@staniscia.net)

  This program is free software; you can redisdivibute it and/or modify
  it under the terms of the GNU General Public License, version 2, as
  published by the Free Software Foundation.

  This program is disdivibuted in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 */
?>


<div class="ewp_dialog ewp_wrap_content" title="EndomondoWP">

    <div class="group">
        <div class="right">


            <p> B) What EWP need for that?

                <input id="ewp_in_eui" maxlength="255" value="" type="text" required
                       placeholder="The endomondo user identification">
                <input id="ewp_in_euwi" maxlength="255" value="" type="text" required
                       placeholder="The Workout identification">

                <input id="ewp_in_ei" maxlength="255" value="" type="text" required
                       placeholder="The event identification">
                <input id="ewp_in_ci" maxlength="255" value="" type="text" required
                       placeholder="The challenge identification">
                <input id="ewp_in_ti" maxlength="255" value="" type="text" required
                       placeholder="The team identification">
            </p>


            <p>
            <p> Do you want specify also the dimension? <a class="ewp_section_control"> more...</a></p>

            <input class="ewp_section_body" id="ewp_in_with" type="number" name="ewp_in_with" maxlength="255"
                   placeholder="Width <?php echo EWP_DEFAUTL_WIDTH; ?> in px">
            <input class="ewp_section_body" id="ewp_in_height" type="number" name="ewp_in_height" maxlength="255"
                   placeholder="Height <?php echo EWP_DEFAUTL_HEIGHT; ?> in px">
            </p>

        </div>


        <div id="ewp_preview_box" class="left">
            <p> A) Witch type of view you want? </p>
            <select id="ewp_type">
                <option value="last-workout">The last workout</option>
                <option value="workout">One workout</option>
                <option value="workout-list">The workouts list</option>
                <option value="challenge">One challenge</option>
                <option value="team">One team preview</option>
                <option value="event">One event</option>
            </select>
            <p>
                <img id="ewp_img_preview"
                     src=""
                     border="0"/>
            </p>
        </div>
    </div>

    <hr>
    <pre id="ewp_preview_shortcode_box"> -- </pre>
    <p id="ewp_btm_apply">
        <button class="button button-primary button-large "> That's the result, now push here!</button>
    </p>


</div>
