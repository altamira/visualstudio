CREATE TABLE [dbo].[Sepultura] (
    [cd_sepultura]         INT          NOT NULL,
    [nm_sepultura]         VARCHAR (60) NULL,
    [vl_vista_sepultura]   FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [vl_entrada_sepultura] FLOAT (53)   NULL,
    CONSTRAINT [PK_Sepultura] PRIMARY KEY CLUSTERED ([cd_sepultura] ASC) WITH (FILLFACTOR = 90)
);

