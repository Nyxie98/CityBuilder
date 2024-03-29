        identification division.
        program-id. game.

        data division.
        working-storage section.

        01 WS-CMD-BOOL          pic 9 value 0. *> Bool for controls
        01 WS-IsClosing-BOOL    pic 9 value 0. *> Stores if we should close the window

        *> Window data
        01 WS-Window.
            05 WS-WindowPos-NUM.
                10 WS-WindowX-NUM pic 9(3) value 800.
                10 WS-WindowY-NUM pic 9(3) value 600.
            05 WS-WindowTitle-STR pic x(16) value "City Builder".

        *> Stores a list of loaded tile images
        01 WS-Tiles-NUM         pic 9 occurs 100 times.
        01 WS-DrawCount-NUM     pic 9(3) value 0.
        01 WS-DrawPos-NUM.
            05 WS-DrawX-NUM     pic 9(4) value 0.
            05 WS-DrawY-NUM     pic 9(4) value 0.

        copy rl-keys.
        copy rl-bool.
        copy rl-def.

        procedure division.
        main-procedure.

        perform init.       *> Initialise the games data, and window
        perform init-data.  *> Initialise the game assets
        perform loop.       *> Game logic loop
        perform dispose.    *> Clear data now the game is closed

        init section.
            call "SetTraceLogLevel" using by value rl-log-error end-call
            call "InitWindow" using
                by value WS-WindowX-NUM WS-WindowY-NUM
                by reference WS-WindowTitle-STR
            end-call
            call "SetTargetFPS" using by value 60 end-call
        .

        init-data section.
            call "b_LoadTexture" using
                by reference "./Assets/Default/roadTexture_25.png"
                returning WS-Tiles-NUM(1)
            end-call

            call "b_SetTextureSize" using
                by value WS-Tiles-NUM(1)
                64 64
            end-call
        .

        loop section.
            perform until WS-IsClosing-BOOL = rl-true
                call "WindowShouldClose" 
                    returning WS-IsClosing-BOOL 
                end-call

                call "BeginDrawing" end-call
                call "b_ClearBackground" using
                    by value 255 255 255 255
                end-call

                *> Draw the world grid
                perform until WS-DrawCount-NUM = 256
                    call "b_DrawTexture" using
                        by value WS-Tiles-NUM(1)
                        WS-DrawX-NUM WS-DrawY-NUM
                        255 255 255 255
                    end-call

                    add 64 to WS-DrawX-NUM
                    if WS-DrawX-NUM = 1024
                        add 64 to WS-DrawY-NUM
                        move 0 to WS-DrawX-NUM
                    end-if

                    add 1 to WS-DrawCount-NUM
                end-perform
                move 0 to WS-DrawCount-NUM
                move 0 to WS-DrawX-NUM
                move 0 to WS-DrawY-NUM

                call "b_DrawText" using
                    by reference "Hello, World!"
                    by value 150 155 50
                    0 0 0 255
                end-call
                call "EndDrawing" end-call
            end-perform
        .

        dispose section.
            call "CloseWindow" end-call
        .
