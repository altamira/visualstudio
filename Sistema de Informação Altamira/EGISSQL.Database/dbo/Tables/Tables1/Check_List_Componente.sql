CREATE TABLE [dbo].[Check_List_Componente] (
    [cd_componente]       INT          NOT NULL,
    [nm_componente]       VARCHAR (60) NULL,
    [cd_tipo_check_list]  INT          NOT NULL,
    [ic_ativo_componente] CHAR (1)     NULL,
    [cd_ordem_componente] INT          NULL,
    [cd_idioma]           INT          NULL,
    [ds_componente]       TEXT         NULL,
    [nm_obs_componente]   VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Check_List_Componente] PRIMARY KEY CLUSTERED ([cd_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Check_List_Componente_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

