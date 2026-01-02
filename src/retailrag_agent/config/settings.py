from pathlib import Path
from pydantic_settings import BaseSettings
from pydantic import Field, ConfigDict, field_validator


class Settings(BaseSettings):
    """
    Configuration centrale du projet RetailRAG Agent.

    Conçue pour :
    - PostgreSQL dans Docker
    - Modèle dimensionnel (Star Schema)
    - SQL analytics
    - RAG SQL (introspection du schéma)
    """

    # -------------------------------------------------------------------------
    # Pydantic (.env local / variables d'environnement Docker)
    # -------------------------------------------------------------------------
    model_config = ConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # -------------------------------------------------------------------------
    # RACINE PROJET
    # -------------------------------------------------------------------------
    project_root: Path = Field(
        default_factory=lambda: Path(__file__).resolve().parents[3],
        description="Racine du projet retailrag-agent.",
    )

    # -------------------------------------------------------------------------
    # LOGS
    # -------------------------------------------------------------------------
    logs: Path = Field(
        default_factory=lambda: Path(__file__).resolve().parents[3] / "logs",
        description="Dossier contenant les logs applicatifs.",
    )

    # -------------------------------------------------------------------------
    # DATABASE (PostgreSQL)
    # Aligné avec la configuration Docker et le test psycopg2 validé
    # -------------------------------------------------------------------------
    DB_HOST: str = Field(
        default="localhost",
        description="Hôte PostgreSQL (localhost ou nom du service Docker).",
    )

    DB_PORT: int = Field(
        default=5433,
        description="Port PostgreSQL exposé par Docker.",
    )

    DB_NAME: str = Field(
        default="retail_analytics",
        description="Nom de la base de données PostgreSQL.",
    )

    DB_USER: str = Field(
        default="retail_user",
        description="Utilisateur PostgreSQL.",
    )

    DB_PASSWORD: str = Field(
        default="retail_pwd",
        description="Mot de passe PostgreSQL.",
    )

    # -------------------------------------------------------------------------
    # RAG / SQL AGENT
    # -------------------------------------------------------------------------
    SCHEMA_CACHE_TTL: int = Field(
        default=3600,
        description="Durée de mise en cache du schéma PostgreSQL (en secondes).",
    )

    MAX_SQL_ROWS: int = Field(
        default=5000,
        description="Nombre maximal de lignes retournées par une requête SQL.",
    )

    # -------------------------------------------------------------------------
    # APPLICATION
    # -------------------------------------------------------------------------
    APP_NAME: str = Field(
        default="RetailRAG Agent",
        description="Nom de l'application (UI / logs).",
    )

    DEBUG: bool = Field(
        default=False,
        description="Active le mode debug de l'application.",
    )

    # -------------------------------------------------------------------------
    # VALIDATION AUTOMATIQUE DES DOSSIERS
    # -------------------------------------------------------------------------
    @field_validator("logs")
    def ensure_logs_dir_exists(cls, v: Path) -> Path:
        """
        Crée automatiquement le dossier de logs s'il n'existe pas.
        """
        v.mkdir(parents=True, exist_ok=True)
        return v


# -----------------------------------------------------------------------------
# Instance globale
# -----------------------------------------------------------------------------
settings = Settings()