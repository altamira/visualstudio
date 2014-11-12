CREATE TABLE [dbo].[Cidade] (
    [cd_pais]       INT          NOT NULL,
    [cd_estado]     INT          NOT NULL,
    [cd_cidade]     INT          NOT NULL,
    [nm_cidade]     VARCHAR (60) NOT NULL,
    [sg_cidade]     CHAR (10)    NULL,
    [cd_ddd_cidade] CHAR (4)     NULL,
    [cd_cep_cidade] CHAR (9)     NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Cidade] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC) WITH (FILLFACTOR = 90)
);

