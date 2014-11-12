CREATE TABLE [dbo].[Registro_Oferta] (
    [cd_registro_oferta]      INT        NOT NULL,
    [dt_registro_oferta]      DATETIME   NULL,
    [dt_base_registro_oferta] DATETIME   NULL,
    [vl_registro_oferta]      FLOAT (53) NULL,
    [ic_testemunha_oferta_1]  CHAR (1)   NULL,
    [ic_testemunha_oferta_2]  CHAR (1)   NULL,
    [ic_testemunha_oferta_3]  CHAR (1)   NULL,
    [ic_testemunha_oferta_4]  CHAR (1)   NULL,
    [ic_testemunha_oferta_5]  CHAR (1)   NULL,
    [ic_testemunha_oferta_6]  CHAR (1)   NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Registro_Oferta] PRIMARY KEY CLUSTERED ([cd_registro_oferta] ASC) WITH (FILLFACTOR = 90)
);

