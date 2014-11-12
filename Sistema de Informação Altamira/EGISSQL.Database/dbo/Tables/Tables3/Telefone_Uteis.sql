CREATE TABLE [dbo].[Telefone_Uteis] (
    [cd_telefone]       INT          NOT NULL,
    [nm_telefone]       VARCHAR (40) NULL,
    [cd_ddd]            VARCHAR (4)  NULL,
    [cd_fone]           VARCHAR (15) NULL,
    [nm_local_telefone] VARCHAR (40) NULL,
    [nm_obs_telefone]   VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Telefone_Uteis] PRIMARY KEY CLUSTERED ([cd_telefone] ASC) WITH (FILLFACTOR = 90)
);

