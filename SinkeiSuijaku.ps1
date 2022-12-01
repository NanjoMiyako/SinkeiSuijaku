$ps_speak=New-Object -ComObject SAPI.SpVoice

function CardReSuffle ($cards, $ClearCard, $newList, $newClearCard){
    $count = $cards.Count


    for($i=0; $i -lt $count; $i++){
        if([int]$ClearCard[$i] -eq 1){
        }else{
            [void]$newList.add($cards[$i])
            [void]$newClearCard.add(0)
        }
    }

    for($i=0; $i -lt ($newList.Count+20); $i++){
        $rnd = Get-Random -Minimum 0 -Maximum ($newList.Count-1)
        $tmp = $newList[$rnd]
        $newList[$rnd] = $newList[0]
        $newList[0] = $tmp
    }
}

function CardMecri([String]$Cmdstr, $cards, $ClearCard, $RestCount){

    $pairs = $Cmdstr.split("-")

    
    if($ClearCard[($pairs[0]-1)] -eq 1){
        $str2 = $pairs[0] + "番のカードは既にめくり済みです"
        Write-host $str2
        $ps_speak.Speak($str2)
        return -1
    }

    if($ClearCard[($pairs[1]-1)] -eq 1){
        $str2 = $pairs[1] + "番のカードは既にめくり済みです"
        Write-host $str2
        $ps_speak.Speak($str2)
        return -1
    }

    $str2 = $pairs[0] + "番のカード:" + $cards[($pairs[0]-1)]
    Write-Host $str2
    $ps_speak.Speak($str2)

    $str2 = $pairs[1] + "番のカード:" + $cards[($pairs[1]-1)]
    Write-Host $str2
    $ps_speak.Speak($str2)

    if($cards[$pairs[0]-1] -eq $cards[$pairs[1]-1]){
        Write-Host　"一致しました"
        $ps_speak.Speak("一致しました")
        $ClearCard[($pairs[0]-1)] = 1
        $ClearCard[($pairs[1]-1)] = 1

        $RestCount.Value = $RestCount.Value-2


    }else{
        Write-host "一致しませんでした"
        $ps_speak.Speak("一致しませんでした")

    }

    $str2 = "残りカードの枚数は" + $RestCount.Value + "枚です"
    Write-Host $str2
    $ps_speak.Speak($str2)



}


$filePath = "C:\hogehoge\powerShellScript\SinkeiSuijaku\card1.txt"
$arr = Get-Content $filePath -Encoding UTF8

$cmd=""

$cards = New-Object System.Collections.ArrayList
$ClearCard = New-Object System.Collections.ArrayList

for($i=0; $i -lt $arr.Length; $i++){
    [void]$cards.add($arr[$i])
    [void]$cards.add($arr[$i])
    [void]$ClearCard.add(0)
    [void]$ClearCard.add(0)
}

for($i=0; $i -lt ($arr.Length+20); $i++){
    $rnd = Get-Random -Minimum 0 -Maximum ($cards.Count-1)
    $tmp = $cards[$rnd]
    $cards[$rnd] = $cards[0]
    $cards[0] = $tmp
}

$RestCount = $cards.Count



 $newList = $cards
 $newClearCard = $ClearCard

 ##Write-Output $newList

while(1){
$ps_speak.Speak("コマンドを入力してください")
$cmd = Read-Host "コマンドを入力してください"

$cmd2 = $cmd.Replace("*", "、あすたりすく、")
$cmd2 = $cmd.Replace("-", "、はいふん、")
$str2 = "入力したコマンド、"+$cmd2
$ps_speak.Speak($str2)


    if($cmd -eq "***"){
        Write-Output "終了します"
        $ps_speak.Speak("終了します")
        break
    }

    if($cmd -eq "*-"){
        Write-Output "残りカードを再シャッフルします"
        $ps_speak.Speak("残りカードを再シャッフルします")

        $prevList = $newList
        $prevClearCard = $newClearCard
        $newList = New-Object System.Collections.ArrayList
        $newClearCard = New-Object System.Collections.ArrayList
        CardReSuffle $prevList $prevClearCard $newList $newClearCard

         ##Write-Output $newList

    }elseif($cmd.IndexOf("-") -ne -1){
        CardMecri $cmd $newList $newClearCard ([ref]$RestCount)

        if([int]$RestCount -eq 0){
            Write-Output "残りカードがなくなりました。クリアです"
            $ps_speak.Speak("残りカードがなくなりました。クリアです")
            break
        } 
    }

}

