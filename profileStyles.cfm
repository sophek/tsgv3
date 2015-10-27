<cfoutput query="qrySchools" maxrows="1">
    <cfif school_level eq "H">
        <cfset padding = 1>
    <cfelse>
        <cfset padding = 10>            
    </cfif>
    
</cfoutput>    

<style>
    #profile {
        width: 1050px;
        height: 1200px;
        background-repeat: no-repeat;
    }
    
    .schoolName {
        font-family: arial;
        font-size: 16pt;
        padding-top: 20;
        padding-left: 30;
        font-weight: bold;
        color: #6175ab;
    }
    
    .align-left {
        text-align: left;
    }
    
    .pad-20 {
        style="padding-left:30px";
    }
    
    .schoolAddress {
        font-family: arial;
        font-size: 11pt;
        padding-top: 0;
        padding-left: 4;
        color: #000000;
        font-weight: bold;
        position: relative;
        left: 0px;
        top: -10px;
    }
    
    .schoolAddress2 {
        font-family: arial;
        font-size: 11pt;
        padding-top: 0;
        padding-left: 4;
        color: #000000;
        font-weight: bold;
        position: relative;
        left: 45px;
        top: -10px;
    }
    
    .headerText {
        font-family: arial;
        font-size: 12pt;
        color: #000000;
        text-transform: uppercase;
        font-weight: bold;
        padding-left: 0;
        padding-top: 10;
    }
    
    .letterGrade {
        background-image: url('letterGrade.png');
        width: 108px;
        height: 82px;
        position: relative;
        top: 0px;
    }
    
    .grade {
        font-family: arial;
        font-size: 30pt;
        color: white;
        padding-left: 30;
        position: relative;
        top: 8;
    }
    
    .schoolTable {
        padding-top: 20;
        padding-left: 20;
        width: 825px;
        position: relative;
        top: -85;
    }
    
    .schoolTable td {
        vertical-align: top;
    }
    
    .profileList {
        list-style-type: none;
    }
    
    .profileList li div {
        float: left;
    }
    
    .float50 {
        position: absolute;
        left: 250;
        "

    }
    
    .campusProfileTable {
        width: 250;
    }
    
    .campusProfileTable td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
        color: #000000;
        padding-top: 8;
        padding-left: 10;
    }
    
    .legendText {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
        color: #000000;
    }
    
    .reportCardTable thead td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
        color: #727372;
    }
    
    .reportCardTable td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
        <cfoutput>
            padding-top: #padding#;
        </cfoutput>
    }
    
    .reportCardTable {
        width: 350px;
    }
    
    .averageLegend {
        position: relative;
        left: -25;
        list-style-type: none;
    }
    
    .averageLegend li {
        float: left;
        padding-left: 10;
        font-size: 7pt;
        font-family: arial;
    }
    
    .redBlock,
    .greenBlock,
    .blueBlock {
        width: 10;
        height: 10;
    }
    
    .redBlock {
        background-color: #e05944;
    }
    
    .greenBlock {
        background-color: #86ab50;
    }
    
    .blueBlock {
        background-color: #6175ab;
    }
    
    .redText {
        color: #e05944;
        font-weight: bold;
    }
    
    .greenText {
        color: #86ab50;
        font-weight: bold;
    }
    
    .blueText {
        color: #6175ab;
        font-weight: bold;
    }
    
    .rankTable {
        width: 300;
    }
    
    .rankTable td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
        padding-top: 10;
        
        
    }
    
    .innovativeTable {
        width: 245;
    }
    
    .innovativeTable td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
    }
    
    .diversityTable {
        width: 150;
    }
    
    .diversityTable td {
        vertical-align: top;
        font-family: arial;
        font-size: 10pt;
    }
    
    .diversityTablePercent {
        vertical-align: top;
        font-family: arial;
        font-size: 9pt;
    }
    
    .meter-green, .meter-blue, .meter-red, .meter-yellow {
        font-family: arial;
        font-size: 8pt;
        color: white;
        height: 15px;
    }
    
    .meter-green {
        background-color: #86ab50;
    }
    
    .meter-blue {
        background-color: #6175ab;
    }
    
    .meter-red {
        background-color: #e05944;

    }
    
    .meter-yellow {
        background-color: #eea72e;

    }
    
    .stateRank {
        color: #e05944;
    }
    
    .peg {
        position: relative;
        top: 15;
        left: 58;
    }
    
    .hr {
        background-color: #c8cc92;
        width: 750;
        height: 1;
        position: relative;
        top: 19;
    }
    
    .vr {
        background-color: #c8cc92;
        width: 1;
        height: 165;
    }
    
    .dot {
        background: #ed0000;
        width: 6px;
        height: 6px;
        border-radius: 50%;
        position: relative;
        top: 7px;
    }
    
    ol li {
        color: #444;
        list-style-type: none;
        float: left;
    }
    
    ol li:first-child:before {
        color: transparent;
    }
    
    ol li:before {
        color: #ed0000;
        content: "\2022";
        font-size: 1.5em;
        padding-right: .15em;
        position: relative;
        top: .1em;
    }
    
    .container {
        width: 1000px !important;
    }
    
    .ol-schoolAddress li {
        float: right;
    }
    
    .sidebyside ul li {
        list-style-image: url('green.png');
    }
    
    li.green {
        list-style-image: url('green.png');
    }
    
    li.blue {
        list-style-image: url('blue.png');
    }
    
    li.red {
        list-style-image: url('red.png');
    }
    
    li.orange {
        list-style-image: url('orange.png');
    }
    
    li p {
        color: ##000;
        vertical-align: top;
        font-family: "proxima-nova",sans-serif;
        font-style: normal;
        font-weight: 400;
        white-space: nowrap;
        width: 50px;
</style>