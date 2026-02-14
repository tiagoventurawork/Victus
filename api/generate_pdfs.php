<?php
$dir = __DIR__ . '/uploads/materials/';
if (!is_dir($dir)) mkdir($dir, 0755, true);

function createPDF($filename, $title, $body) {
    // Simple PDF generator (no libraries needed)
    $text = $title . "\n\n" . $body;
    
    // PDF structure
    $pdf = "%PDF-1.4\n";
    
    // Catalog
    $pdf .= "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n";
    
    // Pages
    $pdf .= "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n";
    
    // Page
    $pdf .= "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n";
    
    // Content stream
    $lines = wordwrap($text, 70, "\n", true);
    $lineArray = explode("\n", $lines);
    
    $stream = "BT\n/F1 16 Tf\n50 740 Td\n";
    $stream .= "(" . str_replace(array('(', ')'), array('\\(', '\\)'), $title) . ") Tj\n";
    $stream .= "/F1 11 Tf\n0 -30 Td\n";
    
    foreach ($lineArray as $i => $line) {
        if ($i === 0) continue; // Skip title
        $clean = str_replace(array('(', ')'), array('\\(', '\\)'), trim($line));
        $stream .= "(" . $clean . ") Tj\n0 -18 Td\n";
    }
    $stream .= "ET";
    
    $streamLen = strlen($stream);
    $pdf .= "4 0 obj\n<< /Length $streamLen >>\nstream\n$stream\nendstream\nendobj\n";
    
    // Font
    $pdf .= "5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n";
    
    // Cross reference
    $pdf .= "xref\n0 6\n";
    $pdf .= "0000000000 65535 f \n";
    
    $offset = 9; // after %PDF-1.4\n
    $pdf .= sprintf("%010d 00000 n \n", $offset);
    $offset += strlen("1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n");
    $pdf .= sprintf("%010d 00000 n \n", $offset);
    $offset += strlen("2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n");
    $pdf .= sprintf("%010d 00000 n \n", $offset);
    $offset += strlen("3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n");
    $pdf .= sprintf("%010d 00000 n \n", $offset);
    $offset += strlen("4 0 obj\n<< /Length $streamLen >>\nstream\n$stream\nendstream\nendobj\n");
    $pdf .= sprintf("%010d 00000 n \n", $offset);
    
    $xrefPos = strpos($pdf, "xref");
    $pdf .= "trailer\n<< /Size 6 /Root 1 0 R >>\n";
    $pdf .= "startxref\n$xrefPos\n%%EOF";
    
    file_put_contents($filename, $pdf);
}

// PDF 1
createPDF($dir . 'guia-boas-vindas.pdf',
    'Guia de Boas-Vindas',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation.

Bem-vinda ao programa Victus!

Este guia vai ajudar-te nos primeiros passos da tua jornada.
Segue as instrucoes e aproveita ao maximo cada aula.

Dicas importantes:
- Assiste a cada video com atencao
- Toma notas durante as aulas
- Pratica os exercicios diariamente
- Partilha as tuas duvidas nos comentarios'
);

// PDF 2
createPDF($dir . 'checklist.pdf',
    'Checklist Semanal',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.

CHECKLIST DA SEMANA:

[ ] Planear as refeicoes da semana
[ ] Fazer lista de compras saudaveis
[ ] Preparar snacks para a semana
[ ] Beber 2 litros de agua por dia
[ ] Fazer 30 minutos de exercicio
[ ] Registar as refeicoes no diario
[ ] Assistir as aulas da semana
[ ] Praticar mindful eating

Dica: Imprime esta checklist e coloca no frigorifico!'
);

// PDF 3
createPDF($dir . 'roda-alimentos.pdf',
    'Tabela Roda dos Alimentos',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.

GRUPOS DA RODA DOS ALIMENTOS:

1. Cereais e derivados (28%)
   Pao, arroz, massa, batata

2. Horticolas (23%)
   Legumes e verduras variadas

3. Fruta (20%)
   3 a 5 porcoes por dia

4. Laticinios (18%)
   Leite, queijo, iogurte

5. Carne, pescado e ovos (5%)
   Preferir peixe e carnes brancas

6. Leguminosas (4%)
   Feijao, grao, lentilhas

7. Gorduras e oleos (2%)
   Preferir azeite

AGUA: 1.5 a 3 litros por dia'
);

echo "3 PDFs criados com sucesso!<br>";
echo "<a href='/victus/api/uploads/materials/guia-boas-vindas.pdf'>Guia Boas-Vindas</a><br>";
echo "<a href='/victus/api/uploads/materials/checklist.pdf'>Checklist</a><br>";
echo "<a href='/victus/api/uploads/materials/roda-alimentos.pdf'>Roda Alimentos</a><br>";