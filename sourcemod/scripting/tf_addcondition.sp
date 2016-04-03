#include <sourcemod>
#include <tf2> 
#include <tf2_stocks>

public Plugin:myinfo = 
{ 
    name        = "TF2: Add Condition", 
    author      = "Drewerth", 
    description = "Alter conditions on one or more players.", 
    version     = "1.0.0", 
    url         = "www.prestige-gaming.org" 
} 

public OnPluginStart() 
{ 
    LoadTranslations( "common.phrases" ); 

    RegAdminCmd( "sm_listcond", Command_ListCondition, ADMFLAG_GENERIC, "Prints the available \"addcond\" conditions to console." );
    RegAdminCmd( "sm_addcond", Command_AddCondition, ADMFLAG_GENERIC, "Usage: sm_addcond <target> <condition> <duration>" ); 
} 

public Action:Command_ListCondition( client, args )
{   
    PrintToConsole( client, "Condition 0  - Slowed" );
    PrintToConsole( client, "Condition 1  - Zoomed [SNIPERS ONLY]" );
    PrintToConsole( client, "Condition 2  - Disguising" );
    PrintToConsole( client, "Condition 3  - Disguised" );
    PrintToConsole( client, "Condition 4  - Cloaked [SPIES ONLY]" );
    PrintToConsole( client, "Condition 5  - Ubercharged" );
    PrintToConsole( client, "Condition 6  - Teleportglow" );
    PrintToConsole( client, "Condition 7  - Taunting" );
    PrintToConsole( client, "Condition 8  - Uberchargefade" );
    PrintToConsole( client, "Condition 9  - UNKNOWN" );
    PrintToConsole( client, "Condition 10 - Teleporting" );
    PrintToConsole( client, "Condition 11 - Kritzkrieged" );
    PrintToConsole( client, "Condition 12 - UNKNOWN" );
    PrintToConsole( client, "Condition 13 - Deadringered" );
    PrintToConsole( client, "Condition 14 - Bonked" );
    PrintToConsole( client, "Condition 15 - Dazed" );
    PrintToConsole( client, "Condition 16 - Buffed" );
    PrintToConsole( client, "Condition 17 - Charging" );
    PrintToConsole( client, "Condition 18 - Demobuff" );
    PrintToConsole( client, "Condition 19 - Critcola" );
    PrintToConsole( client, "Condition 20 - Healing" );
    PrintToConsole( client, "Condition 21 - UNKNOWN" );
    PrintToConsole( client, "Condition 22 - Burning" );
    PrintToConsole( client, "Condition 23 - Overhealed" );
    PrintToConsole( client, "Condition 24 - Jarated" );
    PrintToConsole( client, "Condition 25 - Bleeding" );
    PrintToConsole( client, "Condition 26 - Defensebuffed" );
    PrintToConsole( client, "Condition 27 - Milked" );

    ReplyToCommand( client, "[SM] Conditions list printed to console" ); 

    return Plugin_Handled;
}

public Action:Command_AddCondition( client, args ) 
{
    new String:target[32];
    new String:condition[5];
    new String:duration[32];

    new iCond;
    new Float:iDur;

    if( args < 3 ) 
    { 
        ReplyToCommand( client, "[SM] Usage: sm_addcond <target> <condition> <duration>" ); 
        return Plugin_Handled; 
    }

    GetCmdArg( 1, target, sizeof( target ) );
    GetCmdArg( 2, condition, sizeof( condition ) );
    GetCmdArg( 3, duration, sizeof( duration ) );

    iCond = StringToInt( condition );
    iDur = StringToFloat( duration );

    new String:target_name[MAX_TARGET_LENGTH];
    new target_list[MAXPLAYERS], target_count;
    new bool:check;

    if( ( target_count = ProcessTargetString( target, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof( target_name ), check ) ) <= 0 )
    {
        ReplyToTargetError( client, target_count );
        return Plugin_Handled;
    }

    for( new i = 0; i < target_count; i++ )
    {
        if( iCond == 1 && TF2_GetPlayerClass( target_list[i] ) != TFClass_Sniper )
        {
            return Plugin_Handled;
        }
        else if( iCond == 4 && TF2_GetPlayerClass( target_list[i] ) != TFClass_Spy )
        {
            return Plugin_Handled
        }
        else if( iCond == 7 )
        {
            FakeClientCommand( target_list[i], "taunt" );
            return Plugin_Handled;
        } 
        else if( iCond == 22 )
        {
            TF2_IgnitePlayer( target_list[i], target_list[i] );
            return Plugin_Handled;
        }
        else if( iCond == 25 )
        {
            TF2_MakeBleed( target_list[i], target_list[i], iDur );
            return Plugin_Handled;
        }
        else
        {
            new bool:isCond;
            isCond = TF2_IsPlayerInCondition( target_list[i], TFCond:iCond );       
            if( !isCond )
            {
                TF2_AddCondition( target_list[i], TFCond:iCond, iDur );
            }
        }              
    }

    return Plugin_Handled;
} 
