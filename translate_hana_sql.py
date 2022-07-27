# Importing Path from pathlib2 module
from pathlib import Path
import re

replacements = [('"', ''), 
                ('RETURNS TABLE \(((\r\n|\r|\n).*){1,}\)(\r\n|\r|\n)\)', ''),
                ('TARGET_S4::', 'also-analytics-model-nonprod.1_AQUISICAO_S4.'), 
                ('TARGET::', 'also-analytics-model-nonprod.1_AQUISICAO_S4.'), 
                ('aliansceSonae.4_presentation.dados_mestres.s4::', 'also-analytics-model-nonprod.'), 
                ('\(placeholder."$$IP_ATUALIDADE_DADOS$$"=>:IP_ATUALIDADE_DADOS\)', ''), 
                ('aliansceSonae.3_materialized.dados_mestres.s4::', 'also-analytics-model-nonprod.3_MATERIALIZADO_S4.'), 
                ('return', ''), 
                ("\(IP_ATUALIDADE_DADOS NVARCHAR\(1\) DEFAULT 'P'\)", ''),
                ("""\(placeholder."$$IP_ATUALIDADE_DADOS$$"=>'R'\);""", ""),
                ("NVARCHAR", 'STRING'),
                ("VARBINARY", "BYTES"),
                ("VARCHAR", 'STRING'),
                ('aliansceSonae.2_business.dados_mestres.s4::', 'also-analytics-model-nonprod.2_NEGOCIO_S4.'),
                ('aliansceSonae.2_business.vendas.s4::', 'also-analytics-model-nonprod.2_NEGOCIO_S4.'),
                ('aliansceSonae.2_business.faturamento.s4::', 'also-analytics-model-nonprod.2_NEGOCIO_S4.'),
                ('aliansceSonae.4_presentation.financeiro.s4::', 'also-analytics-model-nonprod.3_MATERIALIZADO_S4.'),
                ('aliansceSonae.4_presentation.vendas.s4::', 'also-analytics-model-nonprod.3_MATERIALIZADO_S4.'),
                (r'^FUNCTION{1}\s', 'CREATE OR REPLACE TABLE FUNCTION '),
                (r'^PROCEDURE{1}\s','CREATE OR REPLACE PROCEDURE '),
                ('LANGUAGE SQLSCRIPT', ""),
	            ('SQL SECURITY INVOKER', ""),
                ('SQL SECURITY DEFINER', ""),
                ('AS (\r\n|\r|\n)*BEGIN', 'AS ('),
	            ('--DEFAULT SCHEMA <default_schema_name>', ""),
                ('COMMIT;', ''),
                ('RETURNS TABLE \(', ''),
                ('\(\)\(\)', '()'),
                ('NOW\(\)', "CURRENT_DATETIME('America/Sao_Paulo')"),
                ('aliansceSonae.1_etl.dados_mestres.s4::SP_ETL_', 'also-analytics-model-nonprod.3_MATERIALIZADO_S4.'),
                ("IP_ATUALIDADE_DADOS STRING \(1\) DEFAULT 'P'", ''),
                ("IP_ATUALIDADE_DADOS NVARCHAR \(1\) DEFAULT 'P'", ''),
                ('\(placeholder.\$\$IP_ATUALIDADE_DADOS\$\$=>:IP_ATUALIDADE_DADOS\)', ''),
                ('FROM DUMMY UNION', 'UNION DISTINCT'),
                ('FROM DUMMY;', ''),
                ('FROM :', 'FROM '),
                ('JOIN :', 'JOIN ')
]

for sql_file in Path.cwd().joinpath('CREATE').iterdir(): ## Modificar a pasta quando necessário
    data = sql_file.read_text(encoding='utf-8')

    for item in replacements:
        data = re.sub(item[0], item[1], data)

    sql_file.write_text(data)
