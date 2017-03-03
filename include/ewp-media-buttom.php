<?php

//Add button on media buttons context
add_action('media_buttons_context', 'add_ewp_button');

//action to add a custom button to the content editor
function add_ewp_button($context)
{
    $img = EWP_URL_ASSETS . "/images/logo_small.png";
    $title = 'Add workout';
    $context .= "<li class='button ewp_fast_tag'><img src='{$img}'/>{$title}</li>";
    return $context;
}

//Add inline content of the botton
add_action('admin_footer', 'add_ewp_inline_popup_content');
function add_ewp_inline_popup_content(){
    include(EWP_DIR . 'admin/views/ewp-html-add-shortcode-editor.inc');
}


add_action( 'admin_enqueue_scripts', 'add_ewp_custom_style' );
function add_ewp_custom_style(){
    wp_enqueue_style('ewp_admin_css', EWP_URL_ASSETS . '/css/ewp-media-button.css', false, '1.0.1');
    wp_enqueue_style("wp-jquery-ui-dialog");
}

add_action( 'admin_enqueue_scripts', 'add_ewp_custom_js' );
function add_ewp_custom_js(){
    wp_enqueue_script('ewp-media-botton', EWP_URL_ASSETS . '/js/ewp-media-button.js', array('jquery-ui-accordion', 'jquery-ui-dialog', 'jquery-core'), '1.0.1', true);
    wp_localize_script('ewp-media-botton', 'EWP_DATA', array('ewpurl' => EWP_URL_ASSETS));
} 