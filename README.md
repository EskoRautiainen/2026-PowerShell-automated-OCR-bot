# What does the script loop do?

1. script captures a screenshot of a fixed screen region.<br>
<img width="500" height="59" alt="image" src="https://github.com/user-attachments/assets/be442942-755d-4adb-98e1-aa3884b1119d" /><br>


2. Runs Tesseract OCR on that screenshot and generates a text file.<br>
<img width="212" height="37" alt="image" src="https://github.com/user-attachments/assets/b62382f0-38ba-4c79-9da4-dfaa6d0f6a14" /><br>
<img width="299" height="66" alt="image" src="https://github.com/user-attachments/assets/60e4b1aa-6b00-49b0-8b4d-7eb54d803e79" /><br>

3. Checks the OCR result for a target string ("Spirit).<br>

4. If not found, performs a left mouse click.<br>

5. Loops with a randomized delay to mimic human behaviour.<br>



## How does it work?
Start Crafting Assistant.Ahk file. (Requires AutoHotkey)<br>
Press F4 to start up the powershell script.<br>
  This starts a loop:<br>
  - Generate screenshot from a defined area.<br>
  - Read text from this screenshot using Tesseract OCR and insert text into text_date_time.txt.<br>
  - Read generated text.txt file and try to find spesified keyword "Spirit"<br>
  - If "Spirit" is not found, send LeftClick mouse input.<br>
  - Repeat the loop until "Spirit" is found.<br>
<br>
Press F6 to kill all PowerShell scripts.<br>
<br>


## Why?
This script can be used to save thousands of clicks while doing repeatible actions to get an expected, rare outcome.
