        identification division.
        program-id. game.

        data division.
        working-storage section.

        01 WS-CMD-BOOL          pic 9 value 0.
        01 WS-IsClosing-BOOL    pic 9 value 0.

        01 WS-Window.
            05 WS-WindowPos-NUM.
                10 WS-WindowX-NUM pic 9(3) value 800.
                10 WS-WindowY-NUM pic 9(3) value 600.

        01 WS-Tiles-NUM         pic 9 occurs 100 times.

        copy rl-keys.
        copy rl-bool.
        copy rl-def.

        procedure division.
        main-procedure.

        perform init.
        perform loop.
        perform dispose.

        init section.
            call "SetTraceLogLevel" using by value rl-log-error end-call
            call "InitWindow" using
                by value WS-WindowX-NUM WS-WindowY-NUM
                by reference "City Builder"
            end-call
            call "SetTargetFPS" using by value 60 end-call
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
