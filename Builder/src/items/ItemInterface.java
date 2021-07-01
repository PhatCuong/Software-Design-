package items;

import Packaging.PackagingInterface;

public interface ItemInterface {
    public String name();
    public PackagingInterface packaging();
    public float price();
}
