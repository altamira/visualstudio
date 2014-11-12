CREATE TABLE [dbo].[Clube_Festas] (
    [cd_festa]        INT          NOT NULL,
    [nm_festa]        VARCHAR (60) NULL,
    [ds_festa]        TEXT         NULL,
    [dt_festa]        DATETIME     NULL,
    [dt_inicio_festa] DATETIME     NULL,
    [dt_fim_festa]    DATETIME     NULL,
    [ic_ativo_festa]  CHAR (1)     NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Clube_Festas] PRIMARY KEY CLUSTERED ([cd_festa] ASC)
);

