# Parameters for text box location from where screenshot is generated.
# Parameters for paths, languages etc.

param(
    [int]$X = 1480,
    [int]$Y = 720,
    [int]$Width = 504,
    [int]$Height = 55,
    [string]$ScreenshotFolder = "$env:USERPROFILE\Desktop\Crafting\Screenshots",
    [string]$TextFolder = "$env:USERPROFILE\Desktop\Crafting\Texts",
    [string]$TessPath = "C:\Program Files\Tesseract-OCR\tesseract.exe",
    [string]$Lang = "eng",
    [switch]$Loop
)

# Base delay for randomization
$BaseDelay = 1.15

# Create folders if missing
New-Item -ItemType Directory -Force -Path $ScreenshotFolder | Out-Null
New-Item -ItemType Directory -Force -Path $TextFolder | Out-Null

# Load SendInput mouse click function
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MouseInput {
    [StructLayout(LayoutKind.Sequential)]
    public struct INPUT {
        public uint type;
        public MOUSEINPUT mi;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MOUSEINPUT {
        public int dx;
        public int dy;
        public uint mouseData;
        public uint dwFlags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    public const int INPUT_MOUSE = 0;
    public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const uint MOUSEEVENTF_LEFTUP = 0x0004;

    public static void LeftClick() {
        INPUT[] inputs = new INPUT[2];
        inputs[0].type = INPUT_MOUSE;
        inputs[0].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
        inputs[1].type = INPUT_MOUSE;
        inputs[1].mi.dwFlags = MOUSEEVENTF_LEFTUP;
        SendInput(2, inputs, Marshal.SizeOf(typeof(INPUT)));
    }
}
"@


function Run-OCR {
    # Screenshot file
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $screenshotFile = Join-Path $ScreenshotFolder "screenshot_$timestamp.png"

    # Take screenshot
    Add-Type -AssemblyName System.Drawing
    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($X, $Y, 0, 0, $bitmap.Size)
    $bitmap.Save($screenshotFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()

    # Run Tesseract OCR
    $text = & $TessPath $screenshotFile stdout -l $Lang

    # Optional: save OCR result
    $textFile = Join-Path $TextFolder "text_$timestamp.txt"
    $text | Out-File $textFile -Encoding utf8

    # Check for "SPIRIT"
    if ($text -match "SPIRIT") {
        Write-Output "Spirit found!"
    } else {
        Write-Output "Not found, clicking..."
        # Human-like click
        [MouseInput]::LeftClick()
    }
}

if ($Loop) {
    Write-Host "Starting OCR loop. Press F6 to kill PowerShell to stop."
    while ($true) {
        Run-OCR

        # Random delay between 0.8x and 1.2x seconds
        $DelaySeconds = Get-Random -Minimum ($BaseDelay * 0.8) -Maximum ($BaseDelay * 1.2)
        Start-Sleep -Seconds $DelaySeconds
    }
} else {
    Run-OCR
}
