package ar.edu.iua.iw3.model.persistence;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import ar.edu.iua.iw3.model.Product;
import jakarta.transaction.Transactional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>{

	Optional<Product> findByProduct(String product);

	Optional<Product> findByProductAndIdNot(String product, long id);
	
	@Query(value = "SELECT count(*) FROM products where id_category=?", nativeQuery = true)
	public Integer countProductsByCategory(long idCategory);
	
	@Transactional
    @Modifying
    @Query(value = "UPDATE products SET stock=? WHERE id=?", nativeQuery = true)
	public int setStock(boolean stock, long idProduct);


}
// SELECT * FROM products WHERE  product=? OR price=? ORDER BY price