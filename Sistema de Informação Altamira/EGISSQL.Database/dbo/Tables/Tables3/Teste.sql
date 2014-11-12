CREATE TABLE [dbo].[Teste] (
    [cd_teste]       INT          NOT NULL,
    [nm_teste]       VARCHAR (40) NOT NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [ds_teste]       TEXT         NULL,
    [nm_obs_teste]   VARCHAR (40) NULL,
    [ic_ativo_teste] CHAR (1)     NULL,
    CONSTRAINT [PK_Teste] PRIMARY KEY CLUSTERED ([cd_teste] ASC) WITH (FILLFACTOR = 90)
);

