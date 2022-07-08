# Importing Path from pathlib2 module
from pathlib2 import Path
import re

replacements = [('"', ''), 
                ('TARGET_S4::', 'also-analytics-model-nonprod.1_AQUISICAO_S4.'), 
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
                (r'^FUNCTION{1}\s', 'CREATE OR REPLACE TABLE FUNCTION '),
                (r'^PROCEDURE{1}\s','CREATE OR REPLACE PROCEDURE'),
                ('LANGUAGE SQLSCRIPT', ""),
	            ('SQL SECURITY INVOKER', ""),
	            ('--DEFAULT SCHEMA <default_schema_name>', ""),
                ('COMMIT;', ''),
                ('\(\)\(\)', '()'),
                ('NOW\(\)', 'CURRENT_TIMESTAMP()'),
                ('aliansceSonae.1_etl.dados_mestres.s4::SP_ETL_', 'also-analytics-model-nonprod.3_MATERIALIZADO_S4.'),
                ("\(IP_ATUALIDADE_DADOS STRING\(1\) DEFAULT 'P'\)", '')
]

for sql_file in Path.cwd().joinpath('TF').iterdir():
    data = sql_file.read_text()

    for item in replacements:
        data = re.sub(item[0], item[1], data)

    sql_file.write_text(data)
